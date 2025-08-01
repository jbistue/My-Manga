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
//    @State private var lastOffsetY: CGFloat = 0

    private let screenHeight = UIScreen.main.bounds.height
    let namespace: Namespace.ID

    init(namespace: Namespace.ID) {
        self.namespace = namespace
    }
    
    var body: some View {
        NavigationStack {
//            ScrollViewReader { proxy in
                ScrollView {
//                    Color.clear
//                        .frame(height: 0)
//                        .id("top")
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(model.mangas) { manga in
                            NavigationLink(value: manga) {
                                CoverView(manga: manga, namespace: namespace)
                                    .cornerRadius(10)
                                    .onAppear {
//                                        if let index = model.mangas.firstIndex(where: { $0.id == manga.id }),
//                                           index >= model.mangas.count - 8 {
//                                            
//                                            // 1. Precargar imágenes de los siguientes mangas (si tienen URL válida)
//                                            let nextMangas = model.mangas.suffix(from: index + 1).prefix(8)
//                                            for next in nextMangas {
//                                                if let url = next.mainPicture {
//                                                    Task {
//                                                        try? await ImageDownloader.shared.image(for: url)
//                                                    }
//                                                }
//                                            }
//
//                                            // 2. Cargar más datos
//                                            Task {
//                                                await model.fetchFilteredMangas()
//                                            }
//                                        }
                                        if let index = model.mangas.firstIndex(where: { $0.id == manga.id }),
                                           index >= model.mangas.count - 8 { // faltan 8 para el final
                                            Task {
                                                await model.fetchFilteredMangas()
                                            }
                                        }
//                                        if let index = model.mangas.firstIndex(where: { $0.id == manga.id }) {
//                                            model.downloadImages(from: index, quantity: 8)
//                                        }
                                    }
//                                    .onAppear {
//                                        if manga == model.mangas.last {
//                                            Task {
//                                                await model.fetchFilteredMangas()
//                                            }
//                                        }
//                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
//                    .background(
//                        GeometryReader { geo in
//                            Color.clear
//                                .onAppear {
//                                    lastOffsetY = geo.frame(in: .global).minY
//                                }
//                                .onChange(of: geo.frame(in: .global).minY) { _, newY in
//                                    // 1. Scroll para mostrar botón arriba
//                                    withAnimation {
//                                        showScrollToTopButton = newY < -100
//                                    }
//
//                                    // 2. Scroll para carga de más datos
//                                    let contentHeight = geo.size.height
//                                    let visibleBottom = contentHeight + newY
//                                    if visibleBottom < screenHeight + 700 {
//                                        Task {
//                                            await model.fetchFilteredMangaCovers()
////                                            await model.fetchFilteredMangas()
//                                        }
//                                    }
//                                }
//                        }
//                    )
//                    .background(
//                        GeometryReader { proxy in
//                            Color.clear
//                                .onChange(of: proxy.frame(in: .global).minY) { _, newValue in
//                                    let contentHeight = proxy.size.height
//                                    let offsetY = newValue
//                                    let visibleBottom = contentHeight + offsetY
//                                    
//                                    if visibleBottom < screenHeight + 700 {
//                                        Task {
////                                            await model.fetchFilteredMangaCovers()
//                                            await model.fetchFilteredMangas()
//                                        }
//                                    }
//                                }
//                        }
//                    )
//                    .background(
//                        GeometryReader { geo in
//                            Color.clear
//                                .onChange(of: geo.frame(in: .global).minY) { _, newY in
//                                    withAnimation {
//                                        showScrollToTopButton = newY < -100
//                                    }
//                                }
//                        }
//                    )
                }
                .navigationTitle(Text("Store"))
                .searchable(text: $searchText, prompt: String(localized: "Search by title"))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .scrollDismissesKeyboard(.interactively)
//                .overlay(alignment: .bottomTrailing) {
//                    if showScrollToTopButton {
//                        Button(action: {
//                            withAnimation {
//                                proxy.scrollTo("top", anchor: .top)
//                            }
//                        }) {
//                            Image(systemName: "arrow.up.circle.fill")
//                                .symbolRenderingMode(.palette)
//                                .foregroundStyle(.white, .blue)
//                                .font(.system(size: 40))
//                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 4)
//                        }
//                        .padding()
//                        .transition(.scale)
//                    }
//                }
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
                    
//            }
//            .onChange(of: model.mangaFilter) { _, newValue in
//                guard newValue != lastFilter else { return }
//                lastFilter = newValue
//                
//                model.mangas = []
//                model.currentPage = 1
//                model.hasMorePages = true
//                
//                Task {
////                    await model.fetchFilteredMangaCovers()
//                    await model.fetchFilteredMangas()
//                }
//            }
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
