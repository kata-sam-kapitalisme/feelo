import Vision
import AVFoundation
import SwiftUI
import Combine

@Observable
final class PoseManager {
    var wristPoints: [CGPoint] = []

    private let visionQueue = DispatchQueue(label: "vision.frame.processing", qos: .userInteractive)
    private var cancellables = Set<AnyCancellable>()
    private var frameCount = 0
    private var bufferSize: CGSize = .zero

    func connect(to publisher: PassthroughSubject<CMSampleBuffer, Never>) {
        publisher
            .receive(on: visionQueue)
            .sink { [weak self] buffer in
                self?.processFrame(buffer)
            }
            .store(in: &cancellables)
    }

    private func processFrame(_ sampleBuffer: CMSampleBuffer) {
        frameCount += 1
        // Throttle every other frame under high thermal load
        if ProcessInfo.processInfo.thermalState.rawValue > ProcessInfo.ThermalState.nominal.rawValue && frameCount % 2 != 0 { return }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let bw = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let bh = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let capturedBufferSize = CGSize(width: bw, height: bh)

        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2
        // Buffer is already landscape-oriented (CameraManager sets videoOrientation on the connection)
        // and un-mirrored (isVideoMirrored = false), so .up is the correct orientation hint.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)

        do {
            try handler.perform([request])
        } catch {
            return
        }

        let fingerJoints: [VNHumanHandPoseObservation.JointName] = [
            .indexTip, .middleTip, .ringTip, .littleTip, .thumbTip, .wrist
        ]
        let observations = request.results ?? []
        var points: [CGPoint] = []
        for obs in observations {
            for joint in fingerJoints {
                if let point = try? obs.recognizedPoint(joint), point.confidence > 0.3 {
                    points.append(point.location)
                }
            }
        }

        Task { @MainActor in
            self.bufferSize = capturedBufferSize
            self.wristPoints = points
        }
    }

    // MARK: - Coordinate Conversion

    func toScreen(_ normalized: CGPoint, in size: CGSize) -> CGPoint {
        // Buffer is un-mirrored; preview is mirrored (selfie) → mirror X to match what the user sees.
        // Flip Y: Vision origin is bottom-left, SwiftUI origin is top-left.
        guard bufferSize != .zero else {
            return CGPoint(
                x: (1 - normalized.x) * size.width,
                y: (1 - normalized.y) * size.height
            )
        }
        // Apply resizeAspectFill viewport correction for non-16:9 devices (e.g. iPad).
        let scale = max(size.width / bufferSize.width, size.height / bufferSize.height)
        let offsetX = (bufferSize.width * scale - size.width) / 2
        let offsetY = (bufferSize.height * scale - size.height) / 2
        return CGPoint(
            x: (1 - normalized.x) * bufferSize.width * scale - offsetX,
            y: (1 - normalized.y) * bufferSize.height * scale - offsetY
        )
    }
}
