import AVFoundation
import Combine
import SwiftUI
import Vision

@Observable
final class PoseSvc {
    var points: [CGPoint] = []

    private let queue = DispatchQueue(
        label: "vision.frame",
        qos: .userInteractive
    )

    private var cancellables = Set<AnyCancellable>()
    private var frame = 0
    private var bufferSize: CGSize = .zero

    func bind(_ publisher: PassthroughSubject<CMSampleBuffer, Never>) {
        publisher
            .receive(on: queue)
            .sink { [weak self] sample in
                self?.process(sample)
            }
            .store(in: &cancellables)
    }

    private func process(_ sample: CMSampleBuffer) {
        frame += 1

        if ProcessInfo.processInfo.thermalState.rawValue >
            ProcessInfo.ThermalState.nominal.rawValue,
           frame % 2 != 0 {
            return
        }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sample) else {
            return
        }

        let width = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let height = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let currentSize = CGSize(
            width: width,
            height: height
        )

        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2

        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .up
        )

        do {
            try handler.perform([request])
        } catch {
            return
        }

        let joints: [VNHumanHandPoseObservation.JointName] = [
            .indexTip,
            .middleTip,
            .ringTip,
            .littleTip,
            .thumbTip,
            .wrist
        ]

        let results = request.results ?? []
        var nextPoints: [CGPoint] = []

        for hand in results {
            for joint in joints {
                if let point = try? hand.recognizedPoint(joint),
                   point.confidence > 0.3 {
                    nextPoints.append(point.location)
                }
            }
        }

        Task { @MainActor in
            self.bufferSize = currentSize
            self.points = nextPoints
        }
    }

    func screenPoint(
        _ norm: CGPoint,
        in size: CGSize
    ) -> CGPoint {
        guard bufferSize != .zero else {
            return CGPoint(
                x: (1 - norm.x) * size.width,
                y: (1 - norm.y) * size.height
            )
        }

        let scale = max(
            size.width / bufferSize.width,
            size.height / bufferSize.height
        )

        let offsetX = (bufferSize.width * scale - size.width) / 2
        let offsetY = (bufferSize.height * scale - size.height) / 2

        return CGPoint(
            x: (1 - norm.x) * bufferSize.width * scale - offsetX,
            y: (1 - norm.y) * bufferSize.height * scale - offsetY
        )
    }
}
