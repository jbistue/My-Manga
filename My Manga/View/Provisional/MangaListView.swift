//
//  MangaListView.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import SwiftUI

struct MangaListView: View {
//    @Environment(MangaViewModel.self) var model
    @State var model = SampleMangaViewModel()
    
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.mangas) { manga in
//                        NavigationLink(destination: Text("Detalle del Manga \(manga.id)")) {
                        NavigationLink(destination: MangaDetailView(manga: manga)) {
                            Text("[#\(manga.id)] \(manga.title ?? "N/A")")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onChange(of: proxy.frame(in: .global).minY) { oldValue, newValue in
                                let contentHeight = proxy.size.height
                                let offsetY = proxy.frame(in: .global).minY

                                let visibleBottom = contentHeight + offsetY

                                if visibleBottom < screenHeight + 200 {
                                    model.fetchMangas()
//                                    Task {
//                                        await model.fetchMangas()
//                                    }
                                }
                            }
                    }
                )
            }
            .navigationTitle(Text("Mangas"))
        }
        .task {
            model.fetchMangas()
//            await model.fetchMangas()
//            await model.getMangas(page: 5, per: 30)
        }
    }
}


#Preview {
//    @Previewable @State var model = MangaViewModel()
//    @Previewable @State var model = SampleMangaViewModel()
//    let model = SampleMangaViewModel()
    
    MangaListView()
//        .environment(model)
//        .environment(mockModel)
}
