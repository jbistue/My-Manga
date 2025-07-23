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
    @State private var searchText = ""
    @State private var debounceTimer: Timer?
    @State private var showScrollToTopButton = false
    
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear
                        .frame(height: 0)
                        .id("top")
                    
                    LazyVStack {
                        ForEach(model.mangas) { manga in
//                            NavigationLink(destination: Text("Detalle del Manga \(manga.id)")) {
                            NavigationLink(destination: MangaDetailView(manga: manga)) {
                                RowListView(manga: manga)
//                                Text("[#\(manga.id)] \(manga.title ?? "N/A")")
//                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
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
//                                            await model.fetchMangas()
                                        }
                                    }
                                }
                        }
                    )
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { _, newY in
                                    withAnimation {
                                        showScrollToTopButton = newY < -100
                                    }
                                }
                        }
                    )
                }
                .navigationTitle(Text("Mangas"))
                .searchable(text: $searchText, prompt: String(localized: "Search by title"))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .overlay(alignment: .bottomTrailing) {
                    if showScrollToTopButton {
                        Button(action: {
                            withAnimation {
                                proxy.scrollTo("top", anchor: .top)
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .blue)
                                .font(.system(size: 40))
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 4)
                        }
                        .padding()
                        .transition(.scale)
                    }
                }
                .onChange(of: searchText) { _, newValue in
                    debounceTimer?.invalidate()
                    
                    if newValue.isEmpty {
                        model.menuLabel = String(localized: "All")
                        model.mangaFilter = "list/mangas"
                        return
                    }
                    
                    debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        DispatchQueue.main.async {
//                            print("search/mangasContains/\(newValue)")
                            model.mangaFilter = "search/mangasContains/\(newValue.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current))"
                        }
                    }

                }
                .mangaFiltersButton()
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
        .task {
            await model.fetchFilteredMangas()
//                await model.fetchMangas()
//                await model.getMangas(page: 5, per: 30)
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
