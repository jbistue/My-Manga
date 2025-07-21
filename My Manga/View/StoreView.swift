//
//  StoreView.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

struct StoreView: View {
    @Environment(MangaViewModel.self) var model
    
    @State private var lastFilter: String = ""

    private let screenHeight = UIScreen.main.bounds.height
    let namespace: Namespace.ID

    init(namespace: Namespace.ID) {
        self.namespace = namespace
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(model.mangas) { manga in
                        NavigationLink(value: manga) {
                            CoverView(manga: manga, namespace: namespace)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
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

                                if visibleBottom < screenHeight + 700 {
                                    Task {
                                        await model.fetchFilteredMangas()
                                    }
                                }
                            }
                    }
                )
            }
            .navigationTitle(Text("Store"))
            .mangaFiltersButton()
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
                    .navigationTransition(.zoom(sourceID: "cover_\(manga.id)", in: namespace))
            }
        }
        .task {
            await model.fetchFilteredMangas()
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
    @Previewable @Namespace var namespace
    
    StoreView(namespace: namespace)
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}
