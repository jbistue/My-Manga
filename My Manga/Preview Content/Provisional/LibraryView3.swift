//
//  LibraryView3.swift
//  My Manga
//
//  Created by Javier Bistue on 5/8/25.
//

import SwiftUI
import SwiftData

struct LibraryView3: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var mangasCollection: [LibraryItemDB]
    
    init() {
        _mangasCollection = Query(sort: [SortDescriptor<LibraryItemDB>(\.id)])
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(mangasCollection) { item in
                    NavigationLink {
                        DetalleLibPruebaView(libraryItem: item)
                            .navigationTitle(Text("Detail"))
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text ("#\(item.id) \(item.volumesOwned)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle(Text("Library"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
//                ToolbarItem {
//                    Button(action: modifyItem) {
//                        Label("Add Item", systemImage: "pencil")
//                    }
//                }
            }
        }
    }
    
//    private func modifyItem() {
//        let newVolumes = [4, 5, 6] // Example new volumes to add
//        for item in mangasCollection {
//            print("Volumes Owned:", item.volumesOwned)
//            item.volumesOwned += newVolumes // Example modification
//            do {
//                try modelContext.save()
//            } catch {
//                print("Error saving item: \(error)")
//            }
//        }
//    }
    
    private func addItem() {
        withAnimation {
            let itemCount = mangasCollection.count
            print("Adding new item, current count:", itemCount)
            let newItem = LibraryItemDB(
                id: itemCount + 1,
                completeCollection: false,
                volumesOwned: [],
                readingVolume: nil
            )
            modelContext.insert(newItem)
//            do {
//                try modelContext.save()
//            } catch {
//                print("Error saving item: \(error)")
//            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(mangasCollection[index])
            }
        }
    }
}


#Preview {
    LibraryView3()
        .modelContainer(for: LibraryItemDB.self, inMemory: true)
}
