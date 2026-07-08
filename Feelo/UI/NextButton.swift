import SwiftUI

struct NextButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(AssetName.Img.nextButton)
                .resizable()
                .scaledToFit()
                .frame(width: 120)
        }
        .buttonStyle(.plain)
    }
}
