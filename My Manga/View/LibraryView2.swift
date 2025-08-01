//
//  LibraryView2.swift
//  My Manga
//
//  Created by Javier Bistue on 29/7/25.
//

import SwiftUI
import SwiftData

struct LibraryView2: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
    
    @Query private var mangasCollection: [LibraryItemDB]
    
    private let imageModel = AsyncImageViewModel()
    
    init() {
        _mangasCollection = Query(sort: [SortDescriptor<LibraryItemDB>(\.id)])
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(mangasCollection) { item in
                        let details = model.mangaBy(id: item.id)
                        
                        LibraryItemCellView(libraryItem: item, mangaItem: details)
                            .task(id: item.id) {
                                await model.fetchMangaIfNeeded(for: item.id)
                            }
                    }
                }
            }
            .navigationTitle(mangasCollection.isEmpty ? Text("") : Text("Library"))
            .padding(.horizontal, 16)
        }
        .overlay {
            if mangasCollection.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.slash")
                } description: {
                    Text(String(localized: "There is no Manga in the library."))
                }
            }
        }
    }
}

#Preview("Librería con Manga", traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    
    LibraryView2()
        .environment(model)
}

#Preview("Librería vacía") {
    @Previewable @State var model = MangaViewModel()
    
    LibraryView2()
        .environment(model)
}
