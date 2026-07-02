import SwiftUI
import Observation

struct HomeSection {
    let title: String
    let items: [HomeItem]
}

struct HomeItem: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

@Observable
final class HomeViewModel {
    let sections: [HomeSection] = [
        HomeSection(
            title: "Pilihan Hari Ini",
            items: [
                HomeItem(title: "Pecahkan gelembung", color: .blue.opacity(0.6)),
                HomeItem(title: "Tarik napas", color: .green.opacity(0.6)),
                HomeItem(title: "Gerak bebas", color: .orange.opacity(0.6)),
            ]
        ),
        HomeSection(
            title: "Cerita",
            items: [
                HomeItem(title: "Si Kancil", color: .purple.opacity(0.5)),
                HomeItem(title: "Bintang Kecil", color: .pink.opacity(0.5)),
                HomeItem(title: "Petualangan Awan", color: .cyan.opacity(0.5)),
            ]
        ),
        HomeSection(
            title: "Emosi",
            items: [
                HomeItem(title: "Senang", color: .yellow.opacity(0.7)),
                HomeItem(title: "Sedih", color: .indigo.opacity(0.5)),
                HomeItem(title: "Marah", color: .red.opacity(0.5)),
                HomeItem(title: "Takut", color: .gray.opacity(0.5)),
            ]
        ),
    ]
}
