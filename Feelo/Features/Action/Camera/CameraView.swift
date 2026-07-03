import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    let cameraManager: CameraManager

    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController(cameraManager: cameraManager)
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

final class CameraViewController: UIViewController {
    private let cameraManager: CameraManager
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var deniedLabel: UILabel?

    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

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

    private func updatePreviewOrientation() {
        guard let connection = previewLayer?.connection,
              connection.isVideoOrientationSupported else { return }
        let orientation = view.window?.windowScene?.interfaceOrientation ?? .landscapeRight
        connection.videoOrientation = orientation == .landscapeLeft ? .landscapeLeft : .landscapeRight
        // Explicitly mirror the preview so the user sees a selfie view.
        if connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }
    }

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupPreview()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted { self?.setupPreview() } else { self?.showDenied() }
                }
            }
        default:
            showDenied()
        }
    }

    private func setupPreview() {
        let layer = AVCaptureVideoPreviewLayer(session: cameraManager.captureSession)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
        previewLayer = layer
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
