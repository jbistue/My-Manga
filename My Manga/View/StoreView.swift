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

//    private let screenHeight = UIScreen.main.bounds.height
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
                                .cornerRadius(10)
                                .onAppear {
            // TODO: prevenir el número de llamadas con un flag
                                    if let index = model.mangas.firstIndex(where: { $0.id == manga.id }),
                                        index == model.mangas.count - 8 { // faltan 8 para el final ???
                                        Task {
                                            print("Precargando mangas...", index, model.mangas.count)
                                            await model.fetchFilteredMangas()
                                        }
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .navigationTitle(Text("Store"))
            .searchable(text: $searchText, prompt: String(localized: "Search by title"))
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .scrollDismissesKeyboard(.interactively)
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
            .refreshable {
                Task {
                    await model.fetchFilteredMangas()
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
        .task {
            if model.mangas.isEmpty {
                print("Fetching initial mangas...")
                await model.fetchFilteredMangas()
            }
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    @Previewable @Namespace var namespace
    
    StoreView(namespace: namespace)
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}
