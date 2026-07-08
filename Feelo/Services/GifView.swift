import SwiftUI
import UIKit
import WebKit

struct GifView: UIViewRepresentable {
    let name: String
    var fit: String = "cover"
    var position: String = "center center"

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isUserInteractionEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        loadGif(into: webView)

        return webView
    }

    func updateUIView(
        _ webView: WKWebView,
        context: Context
    ) {
        if context.coordinator.lastName != name {
            context.coordinator.lastName = name
            loadGif(into: webView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var lastName: String = ""
    }

    private func loadGif(into webView: WKWebView) {
        guard let data = gifData() else {
            print("Missing GIF data: \(name)")
            return
        }

        let base64 = data.base64EncodedString()

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html, body {
                width: 100%;
                height: 100%;
                overflow: hidden;
                background: transparent;
            }

            img {
                width: 100%;
                height: 100%;
                object-fit: \(fit);
                display: block;
            }
        </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(base64)">
        </body>
        </html>
        """

        webView.loadHTMLString(
            html,
            baseURL: nil
        )
    }

    private func gifData() -> Data? {
        if let asset = NSDataAsset(name: name) {
            return asset.data
        }

        if let url = Bundle.main.url(
            forResource: name,
            withExtension: "gif"
        ) {
            return try? Data(contentsOf: url)
        }

        if let url = Bundle.main.url(
            forResource: name,
            withExtension: "gif",
            subdirectory: "Gif"
        ) {
            return try? Data(contentsOf: url)
        }

        if let url = Bundle.main.url(
            forResource: name,
            withExtension: "gif",
            subdirectory: "Res/Gif"
        ) {
            return try? Data(contentsOf: url)
        }

        return nil
    }
}
