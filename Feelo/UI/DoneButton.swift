import SwiftUI

struct DoneButton: View {
    let action: () -> Void
    
    @State private var isPulsing = false
    
    var body: some View {
        Button {
            SoundSvc.shared.click()
            action()
        } label: {
            Image(AssetName.Img.doneButton)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .scaleEffect(isPulsing ? 1.08 : 1.0)
                .animation(
                    .easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true),
                    value: isPulsing
                )
        }
        .buttonStyle(.plain)
        .onAppear {
            isPulsing = true
        }
    }
}
