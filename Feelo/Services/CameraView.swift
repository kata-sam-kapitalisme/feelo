import AVFoundation
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    let camera: CameraSvc

    func makeUIViewController(context: Context) -> CameraVC {
        CameraVC(camera: camera)
    }

    func updateUIViewController(
        _ viewController: CameraVC,
        context: Context
    ) {}
}

final class CameraVC: UIViewController {
    private let camera: CameraSvc

    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var deniedLabel: UILabel?

    init(camera: CameraSvc) {
        self.camera = camera
        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("CameraVC does not support storyboard init.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        checkPermission()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewLayer?.frame = view.bounds
        deniedLabel?.frame = view.bounds

        updatePreviewOrientation()
    }

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupPreview()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self?.setupPreview()
                    } else {
                        self?.showDenied()
                    }
                }
            }

        default:
            showDenied()
        }
    }

    private func setupPreview() {
        let layer = AVCaptureVideoPreviewLayer(
            session: camera.captureSession
        )

        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds

        view.layer.insertSublayer(
            layer,
            at: 0
        )

        previewLayer = layer

        updatePreviewOrientation()
    }

    private func updatePreviewOrientation() {
        guard
            let connection = previewLayer?.connection,
            connection.isVideoOrientationSupported
        else {
            return
        }

        let uiOrientation =
            view.window?.windowScene?.interfaceOrientation ?? .landscapeRight

        connection.videoOrientation =
            uiOrientation == .landscapeLeft ? .landscapeLeft : .landscapeRight

        if connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }
    }

    private func showDenied() {
        let label = UILabel()

        label.text = "Camera access is required.\nPlease enable it in Settings."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.frame = view.bounds

        view.addSubview(label)
        deniedLabel = label
    }
}
