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
    @State private var searchText = ""
    @State private var debounceTimer: Timer?
    @State private var showScrollToTopButton = false

    private let screenHeight = UIScreen.main.bounds.height
    let namespace: Namespace.ID

    init(namespace: Namespace.ID) {
        self.namespace = namespace
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear
                        .frame(height: 0)
                        .id("top")
                    
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
                .navigationTitle(Text("Store"))
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
                            model.mangaFilter = "search/mangasContains/\(newValue.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current))"
                        }
                    }
                    
                }
                .mangaFiltersButton()
                .navigationDestination(for: Manga.self) { manga in
                    MangaDetailView(manga: manga)
                        .navigationTransition(.zoom(sourceID: "cover_\(manga.id)", in: namespace))
                }
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
            if model.mangas.isEmpty {
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
