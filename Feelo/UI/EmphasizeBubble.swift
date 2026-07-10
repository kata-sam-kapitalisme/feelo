import SwiftUI

struct EmphasizeBubble: View {
    let title: String
    let pronunciation: String
    let description: String
    let onSpeakerTap: (() -> Void)?
    
    init(
        title: String,
        pronunciation: String,
        description: String,
        onSpeakerTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.pronunciation = pronunciation
        self.description = description
        self.onSpeakerTap = onSpeakerTap
    }
    
    var body: some View {
        ZStack {
            Image(AssetName.Img.emphasizeText)
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    Text(title)
                        .font(AppFont.bold(36))
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text(pronunciation)
                            .font(AppFont.medium(20))
                        
                        Button {
                            onSpeakerTap?()
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title3)
                                .foregroundStyle(.black)
                        }
                    }
                }
                
                Text(description)
                    .font(AppFont.medium(22))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 32)
        }
        .frame(width: 760, height: 220)
    }
}
