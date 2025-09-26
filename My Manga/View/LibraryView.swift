//
//  LibraryView.swift
//  My Manga
//
//  Created by Javier Bistue on 29/7/25.
//

import SwiftUI
import SwiftData

enum LibraryFilter: String, CaseIterable, Identifiable {
    case all
    case reading
    case complete
    case incomplete
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .all: String(localized: "All")
        case .reading: String(localized: "Reading")
        case .complete: String(localized: "Complete")
        case .incomplete: String(localized: "Incomplete")
        }
    }
}

struct LibraryView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
    
    @Query(sort: [SortDescriptor(\LibraryItemDB.id)]) private var mangasCollection: [LibraryItemDB]
    
    @State private var loadedItems: [(LibraryItemDB, Manga?)] = []
    @State private var libraryFilter: LibraryFilter = .all
    @State private var searchText = ""
    @State private var alphabetical = false
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
            .sorted {
                if alphabetical {
                    guard let title0 = $0.1?.title, let title1 = $1.1?.title else { return false }
                    return title0.localizedStandardCompare(title1) == .orderedAscending
                } else {
                    return $0.0.id < $1.0.id
                }
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
                
            } else if loadedItems.isEmpty {
                
                ProgressView("Loading collections...")
                
            } else {
                
                ScrollView {
//                    LibraryFilterBar(libraryFilter: $libraryFilter)
                    
                    Picker("Filter", selection: $libraryFilter) {
                        ForEach(LibraryFilter.allCases) { option in
                            Text(option.description).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    
                    LazyVStack {
                        ForEach(filteredItems, id: \.0.id) { (item, manga) in
                            if sizeClass == .regular {
                                Button {
                                    selectedItem = item
                                } label: {
                                    LibraryRow(libraryItem: item, mangaItem: manga, selected: selectedItem == item)
                                }
                                .buttonStyle(.plain)
                            } else {
                                NavigationLink(value: item) {
                                    LibraryRow(libraryItem: item, mangaItem: manga, selected: false)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.easeInOut, value: libraryFilter)
                }
                .navigationTitle(mangasCollection.isEmpty ? Text("") : Text("Library"))
                .searchable(text: $searchText, prompt: String(localized: "Search by title"))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .scrollDismissesKeyboard(.interactively)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                alphabetical.toggle()
                            }
                        } label: {
                            Image(systemName: alphabetical ? "numbers" : "textformat.abc")
                                .font(.subheadline)
                                .symbolEffect(.bounce, value: alphabetical)
                        }
                    }
                }
                .onChange(of: libraryFilter) { _, _ in selectedItem = nil }
                .onChange(of: searchText) { _, _ in selectedItem = nil }
                .navigationDestination(for: LibraryItemDB.self) { item in
                    LibraryDetailView(
                        libraryItem: item,
                        mangaItem: model.mangaBy(id: item.id)
                    )
                }
            }
        } detail: {
            if let selected = selectedItem {
                LibraryDetailView(libraryItem: selected, mangaItem: model.mangaBy(id: selected.id))
            } else {
                Text("Select an item")
            }
        }
        .task {
            if !mangasCollection.isEmpty && loadedItems.isEmpty {
                await fetchDetailsOfAllLibraryItems(for: Array(mangasCollection), batchSize: 10)
                lastCollectionCount = mangasCollection.count
            }
        }
        .onChange(of: mangasCollection) { _, newCollection in
            let currentIds = Set(newCollection.map { $0.id })
            loadedItems.removeAll { !currentIds.contains($0.0.id) }

            let loadedIds = Set(loadedItems.map { $0.0.id })
            let newOnes = newCollection.filter { !loadedIds.contains($0.id) }
            Task {
                await fetchDetailsOfAllLibraryItems(for: newOnes, batchSize: 10)
            }

            lastCollectionCount = newCollection.count
        }
        .onChange(of: model.errorMessage) { _, newError in
            if newError == nil {
                Task {
                    loadedItems = []
                    await fetchDetailsOfAllLibraryItems(for: Array(mangasCollection), batchSize: 10)
                }
            }
        }
        .refreshable {
            Task {
                loadedItems = []
                await fetchDetailsOfAllLibraryItems(for: Array(mangasCollection), batchSize: 10)
            }
        }
    }
    
    private func fetchSingleManga(id: Int) async -> Manga? {
        if model.mangaBy(id: id) == nil {
            await model.fetchMangaIfNeeded(for: id)
        }
        return model.mangaBy(id: id)
    }
    
    private func fetchDetailsOfAllLibraryItems(for items: [LibraryItemDB], batchSize: Int = 10) async {
        guard !items.isEmpty else { return }

        // Mapa id -> item (para reconstruir la tupla al final del lote)
        let idToItem = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        // Solo IDs para no sacar modelo de SwiftData fuera del MainActor
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
}

#Preview("Biblioteca con Manga", traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    
    LibraryView()
        .environment(model)
        .environment(imageModel)
}

#Preview("Biblioteca vacía") {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    
    LibraryView()
        .environment(model)
        .environment(imageModel)
        .modelContainer(for: LibraryItemDB.self, inMemory: true)
}
