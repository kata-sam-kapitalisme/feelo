import SwiftUI
import WebKit

struct GifImageView: UIViewRepresentable {
    let name: String
    var objectFit: String = "cover"

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isUserInteractionEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else { return webView }
        let directory = url.deletingLastPathComponent()
        let filename = url.lastPathComponent
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          html, body { width: 100%; height: 100%; overflow: hidden; background: transparent; }
          img { width: 100%; height: 100%; object-fit: \(objectFit); display: block; }
        </style>
        </head>
        <body>
          <img src="\(filename)">
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: directory)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
