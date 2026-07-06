import SwiftUI

/// A reusable cloud-shaped text bubble backed by the `text-cloud` SVG asset.
/// The SVG has a natural aspect ratio of 934:238 (~3.92:1).
struct CloudTextBubble: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 33, weight: .bold))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 48)
            .padding(.vertical, 24)
            .frame(width: 934, height: 238)
            .background(
                Image("text-cloud")
                    .resizable()
                    .scaledToFill()
            )
    }
}
