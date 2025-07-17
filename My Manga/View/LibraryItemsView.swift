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
    
    @Query private var libraryItems: [LibraryItemDB]
    
//    let namespace: Namespace.ID
    
    init(predicate: Predicate<LibraryItemDB>, namespace: Namespace.ID) {
//        self.namespace = namespace
        _libraryItems = Query(filter: predicate, sort: [SortDescriptor<LibraryItemDB>(\.id)])
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(libraryItems) { item in
//                    NavigationLink(value: movie) {
                        LibraryItemCellView(manga: item)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    @Previewable @Namespace var namespace
    
    LibraryItemsView(predicate: #Predicate<LibraryItemDB> { $0.readingVolume != nil }, namespace: namespace)
        .environment(model)
}
