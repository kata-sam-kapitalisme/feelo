//
//  CompletionView.swift
//  Feelo
//
//  Created by Carolyn Santana on 06/07/26.
//

import SwiftUI

struct CompletionView: View {
    @Environment(Router.self) private var router
    
    private var scenario: Scenario {
        router.selectedScenario ?? ScenarioRepository.defaultScenario
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // MARK: Background
                Image("bg_waves")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // MARK: Content
                VStack(spacing: geo.size.height * 0.04) {
                    
                    // Header
                    VStack(spacing: 20) {
                        Text("Petualangan selesai!")
                            .font(.custom("Fredoka-Bold", size: 40))
                            .foregroundStyle(.white)
                        
                        Text("Stiker baru!")
                            .font(.custom("Fredoka-SemiBold", size: 36))
                            .foregroundStyle(.white)
                    }
                    
                    // Sticker
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 140)
                            .fill(Color(red: 82/255, green: 146/255, blue: 58/255))
                            .shadow(
                                color: .black.opacity(0.28),
                                radius: 10,
                                x: 0,
                                y: 10
                            )
                        
                        Image(scenario.badgeImage)
                            .resizable()
                            .scaledToFit()
                            .padding(22)
                        
                    }
                    .frame(
                        width: geo.size.width * 0.32,
                        height: geo.size.width * 0.32
                    )
                    
                    // Sticker Name
                    Text(scenario.badgeTitle)
                        .font(.custom("Fredoka-Bold", size: 50))
                        .foregroundStyle(.white)
                    
                    // Back Home Button
                    Button {
                        router.currentScreen = .home
                    } label: {
                        Text("Back Home")
                            .font(.custom("Fredoka-SemiBold", size: 36))
                            .foregroundStyle(.black)
                            .frame(
                                width: geo.size.width * 0.22,
                                height: 60
                            )
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center,
                )
                .padding(.horizontal, 40)
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    let router = Router()
    router.selectedScenario = ScenarioRepository.all.first
    
    return CompletionView()
        .environment(router)
}
