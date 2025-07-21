//
//  MangaListView.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import SwiftUI

struct MangaListView: View {
    @Environment(MangaViewModel.self) var model

    @State private var lastFilter: String = ""
    
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.mangas) { manga in
//                        NavigationLink(destination: Text("Detalle del Manga \(manga.id)")) {
                        NavigationLink(destination: MangaDetailView(manga: manga)) {
                            RowListView(manga: manga)
//                            Text("[#\(manga.id)] \(manga.title ?? "N/A")")
//                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onChange(of: proxy.frame(in: .global).minY) { _, newValue in
                                let contentHeight = proxy.size.height
                                let offsetY = newValue

                                let visibleBottom = contentHeight + offsetY

                                if visibleBottom < screenHeight + 200 {
                                    Task {
                                        await model.fetchFilteredMangas()
//                                        await model.fetchMangas()
                                    }
                                }
                            }
                    }
                )
            }
            .navigationTitle(Text("Mangas"))
            .mangaFiltersButton()
        }
//        .mangaFiltersButton(mangaFilter: $bindableModel.mangaFilter)
        .task {
            await model.fetchFilteredMangas()
//            await model.fetchMangas()
//            await model.getMangas(page: 5, per: 30)
        }
        .onChange(of: model.mangaFilter) { _, newValue in
            guard newValue != lastFilter else { return }
            lastFilter = newValue

            model.mangas = []
            model.currentPage = 1
            model.hasMorePages = true

            Task {
                await model.fetchFilteredMangas()
            }
        }
    }
}


#Preview {
    @Previewable @State var model = MangaViewModel()
    
    MangaListView()
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}
