//
//  LibraryView.swift
//  My Manga
//
//  Created by Javier Bistue on 29/7/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
    
    @Query(sort: [SortDescriptor(\LibraryItemDB.id)]) private var mangasCollection: [LibraryItemDB]
    
    @State private var loadedItems: [(LibraryItemDB, Manga?)] = []
    @State private var libraryFilter: LibraryFilter = .reading
    @State private var searchText = ""
    
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
            } else {
//        NavigationStack {
//            List {
                ScrollView {
                    LibraryFilterBar(libraryFilter: $libraryFilter)
                    
                    LazyVStack {
                        ForEach(filteredItems, id: \.0.id) { (item, manga) in
                            LibraryItemCellView(libraryItem: item, mangaItem: manga)
                        }
                    }
                }
                .navigationTitle(mangasCollection.isEmpty ? Text("") : Text("Library"))
                .padding(.horizontal, 16)
                .scrollIndicators(.hidden)
                .searchable(text: $searchText, prompt: String(localized: "Search by title"))
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .scrollDismissesKeyboard(.interactively)
            }
        } detail: {
            Text("Select an item")
        }
        .task {
            await fetchDetailsOfAllLibraryItems()
        }
//        }
    }

    private func fetchDetailsOfAllLibraryItems() async {
        var temp: [(LibraryItemDB, Manga?)] = []
            
        for item in mangasCollection {
            if model.mangaBy(id: item.id) == nil {
                await model.fetchMangaIfNeeded(for: item.id)
            }
            let manga = model.mangaBy(id: item.id)
            temp.append((item, manga))
        }
            
        loadedItems = temp
    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(mangasCollection[index])
//            }
//        }
//    }
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
