//
//  LibraryItemsView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/7/25.
//

import SwiftUI
import SwiftData

struct LibraryItemsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
//    @Environment(AsyncImageViewModel.self) var imageModel
    
    @Query private var libraryItems: [LibraryItemDB]
    
    @State private var selectedManga: Manga? = nil
//    @State private var detailsDict: [Int: Manga] = [:]
    @Binding var detailsDict: [Int: Manga]
    
    private let mangaPorDefecto = Manga.test
//    let modelImage = AsyncImageViewModel()

    init(predicate: Predicate<LibraryItemDB>, detailsDict: Binding<[Int: Manga]>) {
        _libraryItems = Query(filter: predicate, sort: [SortDescriptor<LibraryItemDB>(\.id)])
        _detailsDict = detailsDict
    }
    
//    func fetchMangaIfNeeded(for id: Int) async {
//        if detailsDict[id] != nil { return }
//        
//        await model.getMangaDetail(id: id)
//        
//        if let fetchedManga = model.manga {
//            if detailsDict[id] == nil {
//                detailsDict[id] = fetchedManga
//            }
//        }
//    }
    
    var body: some View {
//        @Binding var detailsDict: [Int: Manga]
        
        ScrollView {
            LazyVStack {
//            List {
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(libraryItems) { item in
                    let manga = detailsDict[item.id]

                    Button {
                        if let manga {
                            selectedManga = manga
                        }
                    } label: {
                        LibraryItemCellView(libraryItem: item, mangaItem: manga ?? mangaPorDefecto)
//                            .task {
//                                await fetchMangaIfNeeded(for: item.id)
//                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
//        .task {
//            for item in libraryItems {
//                if detailsDict[item.id] == nil {
//                    await model.getMangaDetail(id: item.id)
//                    if let loadedManga = model.manga {
//                        detailsDict[item.id] = loadedManga
//                    }
//                }
//            }
//        }
        .navigationDestination(item: $selectedManga) { manga in
            MangaDetailView(manga: manga)
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    
    LibraryItemsView(predicate: #Predicate<LibraryItemDB> { $0.readingVolume != nil },
                        detailsDict: .constant([Int: Manga]()))
        .environment(model)
        .environment(imageModel)
}
