import AVFoundation
import Combine
import UIKit

final class CameraManager: NSObject {
    let sampleBufferPublisher = PassthroughSubject<CMSampleBuffer, Never>()

    private let session = AVCaptureSession()
    private let frameQueue = DispatchQueue(label: "camera.frames", qos: .userInteractive)
    private var dataOutput: AVCaptureVideoDataOutput?

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            session.commitConfiguration()
            return
        }

        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        ]
        output.setSampleBufferDelegate(self, queue: frameQueue)
        output.alwaysDiscardsLateVideoFrames = true

        if session.canAddOutput(output) {
            session.addOutput(output)
            dataOutput = output
        }

        session.commitConfiguration()
    }

    /// Call from main thread when interface orientation changes.
    /// Rotates the pixel data in the output buffer so Vision receives landscape-correct frames.
    func updateOrientation(_ interfaceOrientation: UIInterfaceOrientation) {
        guard let conn = dataOutput?.connection(with: .video) else { return }
        let avOrientation: AVCaptureVideoOrientation = interfaceOrientation == .landscapeLeft ? .landscapeLeft : .landscapeRight
        if conn.isVideoOrientationSupported {
            conn.videoOrientation = avOrientation
        }
        // Keep un-mirrored so Vision uses .up — mirroring is handled in toScreen
        if conn.isVideoMirroringSupported {
            conn.automaticallyAdjustsVideoMirroring = false
            conn.isVideoMirrored = false
        }
    }

    func start() {
        guard !session.isRunning else { return }
        frameQueue.async { self.session.startRunning() }
    }

    func stop() {
        guard session.isRunning else { return }
        session.stopRunning()
    }

    var captureSession: AVCaptureSession { session }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        sampleBufferPublisher.send(sampleBuffer)
    }
}
