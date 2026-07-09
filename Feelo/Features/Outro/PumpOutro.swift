import SwiftUI

struct PumpOutro: View {
    @Environment(AppNav.self) private var nav
    @State private var outroOverlay = false
    
    private let text1 = "Kamu berhasil mengisi bolanya lagi!"
    private let text2 = "Sekarang, kamu bisa bermain bersama lagi."
    
    var body: some View {
        GeometryReader { geo in
            let scale = min(1.0, min(geo.size.width / AppConst.Ref.w, geo.size.height / AppConst.Ref.h))
            let bgH = max(geo.size.height, geo.size.width * AppConst.Ref.h / AppConst.Ref.w)
            let bgOffset = -max(0, bgH - geo.size.height)
            
            ZStack {
                Image(AssetName.Img.bgSky)
                    .resizable()
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()
                
                GifView(name: AssetName.Gif.pumpBg)
                    .frame(width: geo.size.width, height: bgH)
                    .offset(y: bgOffset)
                    .ignoresSafeArea()
                
                let charSize = bgH * AppConst.Stage.pumpCharSmall
                GifView(name: AssetName.Gif.pump5, fit: "contain")
                    .frame(width: charSize, height: charSize)
                    .position(x: geo.size.width / 2, y: geo.size.height - charSize / 2)
                
                VStack {
                    Spacer()
                        .frame(maxHeight: 40)
                    
                    CloudBubble(
                        title: text1,
                        text: text2,
                        important: true,
                        scale: scale
                    )
                    
                    Spacer()
                }
                .padding(32 * scale)
                
                if outroOverlay {
                    let cardWidth = geo.size.width * 0.32
                    
                    // darkened layer
                    Color.black
                        .opacity(0.6)
                        .ignoresSafeArea()
                    
                    // the card
                    Image(AssetName.Img.kecewaOutro)
                        .resizable()
                        .scaledToFit()
                        .frame(width: cardWidth)
                    
                    //Finish button edit ini samantha
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            NextButton {
                                nav.finishStory()
                            }
                        }
                        .padding(.trailing, 32)
                        .padding(.bottom, 32)
                    }
                }
            }
            .onAppear {
                SoundSvc.shared.playAmbient()
                SoundSvc.shared.playVoice(AssetName.Voiceover.pompa_outro)
            }
            .onDisappear {
                SoundSvc.shared.stopVoice()
            }
            .tapSound {
                guard !outroOverlay else { return }
                outroOverlay = true
            }
        }
        .ignoresSafeArea()
    }
}

#Preview(traits: .landscapeLeft) {
    PumpOutro()
        .environment(AppNav())
}
