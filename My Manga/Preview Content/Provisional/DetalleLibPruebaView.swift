//
//  DetalleLibPruebaView.swift
//  My Manga
//
//  Created by Javier Bistue on 5/8/25.
//

import SwiftUI
import SwiftData

struct DetalleLibPruebaView: View {
    @Environment(\.modelContext) private var modelContext
    
//    @Query private var mangasCollection: [LibraryItemDB]
    
    private let libraryItem: LibraryItemDB
    
    init(libraryItem: LibraryItemDB) {
        self.libraryItem = libraryItem
////        _mangasCollection = Query(sort: [SortDescriptor<LibraryItemDB>(\.id)])
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("# \(libraryItem.id)")
                .font(.headline)
            
            //        Spacer()
            //
            //        Button {
            //            isFormPresented = true
            //        } label: {
            //            Image(systemName: "ellipsis.circle")
            //                .font(.title2)
            //                .fontWeight(.light)
            //        }
            //    }
            //    .font(.headline)
            
            HStack {
                Text(libraryItem.completeCollection ? "Complete" : "Incomplete")
                
                Text("(\(libraryItem.volumesOwned.count))") ///\(mangaItem?.volumes ?? 0))")
            }
            .font(.subheadline)
            .foregroundColor(libraryItem.completeCollection ? .green : .red)
            
            Text(libraryItem.volumesOwned.sorted(by: <).map { String($0) }.formatted(.list(type: .and)))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(libraryItem.readingVolume.map { "\($0)" } ?? "-")
                .font(.caption)
        }
        .padding(.horizontal, 20)
        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                EditButton()
//            }
//            ToolbarItem {
//                Button(action: addItem) {
//                    Label("Add Item", systemImage: "plus")
//                }
//            }
            ToolbarItem {
                Button(action: modifyItem) {
                    Label("Add Item", systemImage: "pencil")
                }
            }
        }
    }
    
    private func modifyItem() {
        let newVolumes = [4, 5, 6] // Example new volumes to add
        print("Volumes Owned antes:", libraryItem.volumesOwned)
        libraryItem.volumesOwned += newVolumes
//        for item in mangasCollection {
        print("Volumes Owned después:", libraryItem.volumesOwned)
        do {
            try modelContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
//        }
    }
}

#Preview {
    DetalleLibPruebaView(libraryItem: LibraryItemDB(
        id: 42,
        completeCollection: false,
        volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
        readingVolume: 4))
}
