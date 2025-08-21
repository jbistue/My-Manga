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
                            MangaCoverView(manga: manga, namespace: namespace)
                                .cornerRadius(10)
                                .onAppear {
                                    guard model.errorMessage == nil else { return }
                                    if let index = model.mangas.firstIndex(where: { $0.id == manga.id }),
                                        // cuando faltan 6 portadas para el final se cargan más Mangas
                                        index == model.mangas.count - 6 {
                                        print("Fetching more mangas...")
                                        Task {
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
                StoreDetailView(manga: manga)
                    .navigationTransition(.zoom(sourceID: "cover_\(manga.id)", in: namespace))
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
            .overlay(alignment: .bottom) {
                if let errorMessage = model.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .background(Color.red.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Button("Retry") {
                            Task(priority: .userInitiated) {
                                if model.demographics.isEmpty {
                                    model.loadMangaClassifications()
                                }
                                await model.fetchFilteredMangas()
                            }
                        }
                        .padding(.top, 4)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .task {
            if model.mangas.isEmpty, model.errorMessage == nil {
                await model.fetchFilteredMangas()
            }
        }
    }
}

#Preview("Sin errores") {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    @Previewable @Namespace var namespace
    
    StoreView(namespace: namespace)
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}

#Preview("Con errores") {
    @Previewable @State var model = MangaViewModel()
    @Previewable @Namespace var namespace
    
    StoreView(namespace: namespace)
        .task {
            model.loadMangaClassifications()
        }
        .onAppear {
            model.errorMessage = "No se pudo conectar al servidor. Verifica tu conexión a internet."
        }
        .environment(model)
}
