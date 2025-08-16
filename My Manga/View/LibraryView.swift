//
//  LibraryView.swift
//  My Manga
//
//  Created by Javier Bistue on 29/7/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
    
    @Query(sort: [SortDescriptor(\LibraryItemDB.id)]) private var mangasCollection: [LibraryItemDB]
    
    @State private var loadedItems: [(LibraryItemDB, Manga?)] = []
    @State private var libraryFilter: LibraryFilter = .all
    @State private var searchText = ""
    @State private var selectedItem: LibraryItemDB?
    @State private var lastCollectionCount = 0
    
    private var filteredItems: [(LibraryItemDB, Manga?)] {
        loadedItems
            .filter { (item, _) in
                switch libraryFilter {
                case .all:
                    return true
                case .reading:
                    return item.readingVolume != nil
                case .complete:
                    return item.completeCollection
                case .incomplete:
                    return !item.completeCollection
                }
            }
            .filter { (_, manga) in
                guard !searchText.isEmpty else { return true }
                guard let title = manga?.title else { return false }
                return title.localizedStandardContains(searchText)
            }
    }
    
    var body: some View {
        NavigationSplitView {
            if mangasCollection.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.slash")
                } description: {
                    Text(String(localized: "There is no Manga in the library."))
                }
                // MARK: - Para pruebas: permite añadir unos 1.000 Manga a la colección para comprobar el tiempo de carga inicial
                //                .toolbar {
                //                    ToolbarItem(placement: .topBarLeading) {
                //                        Button {
                //                            addThousandItems()
                //                        } label: {
                //                            Image(systemName: "document.badge.plus")
                //                                .font(.callout)
                //                        }
                //                    }
                //                }
            } else if loadedItems.isEmpty {
                ProgressView("Loading collections...")
            } else {
                ScrollView {
                    LibraryFilterBar(libraryFilter: $libraryFilter)
                    
                    LazyVStack {
                        ForEach(filteredItems, id: \.0.id) { (item, manga) in
                            if sizeClass == .regular {
                                Button {
                                    selectedItem = item
                                } label: {
                                    LibraryItemCellView(libraryItem: item, mangaItem: manga)
                                }
                                .buttonStyle(.plain)
                            } else {
                                NavigationLink(value: item) {
                                    LibraryItemCellView(libraryItem: item, mangaItem: manga)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .navigationTitle(mangasCollection.isEmpty ? Text("") : Text("Library"))
                .searchable(text: $searchText, prompt: String(localized: "Search by title"))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: libraryFilter) { _, _ in selectedItem = nil }
                .onChange(of: searchText) { _, _ in selectedItem = nil }
                .navigationDestination(for: LibraryItemDB.self) { item in
                    ItemDBDetailView(
                        libraryItem: item,
                        mangaItem: model.mangaBy(id: item.id)
                    )
                }
// MARK: - Para pruebas: permite eliminar todos los Manga de la colección
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            deleteAllItems()
//                            deleteItems(offsets: mangasCollection.indices)
                        } label: {
                            Image(systemName: "trash")
                                .font(.callout)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        } detail: {
            if let selected = selectedItem {
                ItemDBDetailView(libraryItem: selected, mangaItem: model.mangaBy(id: selected.id))
            } else {
                Text("Select an item")
            }
        }
        .task {
            if !mangasCollection.isEmpty && loadedItems.isEmpty {
                await fetchDetailsOfAllLibraryItems(for: Array(mangasCollection), batchSize: 20)
                lastCollectionCount = mangasCollection.count
            }
        }
        .onChange(of: mangasCollection) { _, newCollection in
            let currentIds = Set(newCollection.map { $0.id })
            loadedItems.removeAll { !currentIds.contains($0.0.id) }

            let loadedIds = Set(loadedItems.map { $0.0.id })
            let newOnes = newCollection.filter { !loadedIds.contains($0.id) }
            Task { await fetchDetailsOfAllLibraryItems(for: newOnes, batchSize: 20) }

            lastCollectionCount = newCollection.count
        }
    }
    
    @MainActor
    private func fetchSingleManga(id: Int) async -> Manga? {
        if model.mangaBy(id: id) == nil {
            await model.fetchMangaIfNeeded(for: id)
        }
        return model.mangaBy(id: id)
    }
    
    private func fetchDetailsOfAllLibraryItems(for items: [LibraryItemDB], batchSize: Int = 20) async {
        // Evitar tares si no hay nada en la Biblioteca
        guard !items.isEmpty else { return }

        // Mapa id -> item (para reconstruir la tupla al final del lote)
        let idToItem = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        // Solo IDs para no sacar modelos de SwiftData fuera del MainActor
        let ids = items.map { $0.id }

        for batch in ids.chunked(into: batchSize) {
            var batchResults: [(LibraryItemDB, Manga?)] = []

            await withTaskGroup(of: (Int, Manga?).self) { group in
                for id in batch {
                    group.addTask {
                        let manga = await fetchSingleManga(id: id)
                        return (id, manga)
                    }
                }

                for await (id, manga) in group {
                    if let item = idToItem[id] {
                        batchResults.append((item, manga))
                    }
                }
            }

            await MainActor.run {
                let existing = Set(loadedItems.map { $0.0.id })
                loadedItems.append(contentsOf: batchResults.filter { !existing.contains($0.0.id) })
            }
        }
    }
    
//    private func addThousandItems() {
//        for manga in model.mangas {
//            for i in 0..<1000 {
//                let updatedVolumesOwned = [1]
//                let newItem = LibraryItemDB(
//                    id: 1004 + i,
//                    completeCollection: manga.volumes == updatedVolumesOwned.count,
//                    volumesOwned: updatedVolumesOwned,
//                    readingVolume: nil
//                )
//                modelContext.insert(newItem)
//            }
//        }
//    }
    
    private func deleteAllItems() {
        withAnimation {
            for item in mangasCollection {
                modelContext.delete(item)
            }
//            for index in offsets {
//                modelContext.delete(mangasCollection[index])
//            }
        }
    }
}

#Preview("Librería con Manga", traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    
    LibraryView()
        .environment(model)
        .environment(imageModel)
}

#Preview("Librería vacía") {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    
    LibraryView()
        .environment(model)
        .environment(imageModel)
        .modelContainer(for: LibraryItemDB.self, inMemory: true)
}
