import AVFoundation
import Combine
import UIKit

final class CameraSvc: NSObject {
    let frames = PassthroughSubject<CMSampleBuffer, Never>()

    private let session = AVCaptureSession()
    private let queue = DispatchQueue(
        label: "camera.frames",
        qos: .userInteractive
    )

    private var output: AVCaptureVideoDataOutput?

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard
            let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front
            ),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            session.commitConfiguration()
            return
        }

        session.addInput(input)

        let dataOutput = AVCaptureVideoDataOutput()

        dataOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String:
                kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        ]

        dataOutput.setSampleBufferDelegate(
            self,
            queue: queue
        )

        dataOutput.alwaysDiscardsLateVideoFrames = true

        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            output = dataOutput
        }

        session.commitConfiguration()
    }

    func setOrientation(_ ui: UIInterfaceOrientation) {
        guard let connection = output?.connection(with: .video) else {
            return
        }

        let orientation: AVCaptureVideoOrientation =
            ui == .landscapeLeft ? .landscapeLeft : .landscapeRight

        if connection.isVideoOrientationSupported {
            connection.videoOrientation = orientation
        }

        if connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = false
        }
    }

    func start() {
        guard !session.isRunning else {
            return
        }

        queue.async {
            self.session.startRunning()
        }
    }

    func stop() {
        guard session.isRunning else {
            return
        }

        session.stopRunning()
    }

    var captureSession: AVCaptureSession {
        session
    }
}

extension CameraSvc: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        frames.send(sampleBuffer)
    }
}
