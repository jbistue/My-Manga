//
//  LibraryItemCellView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/7/25.
//

import SwiftUI

struct LibraryItemCellView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(MangaViewModel.self) var model
    
//    @State private var mangaItem: Manga? = nil
    @State private var isFormPresented: Bool = false
    
    let libraryItem: LibraryItemDB
    let mangaItem: Manga?
    
//    init(libraryItem: LibraryItemDB) {
//        self.libraryItem = libraryItem
//    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            MangaImageView(url: mangaItem?.mainPicture)
//                .scaledToFit()
                .frame(maxWidth: 70, minHeight: 50, maxHeight: 100, alignment: .center)
//                .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                HStack {
//                    Text("# \(libraryItem.id)")
                    
                    if let title = mangaItem?.title {
                        Text(title)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(String(localized: "Manga data not available"))
                            .foregroundColor(.red)
                        
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Button {
                        isFormPresented = true
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .fontWeight(.light)
                    }
                    .disabled(mangaItem == nil)
                }
                .font(.headline)
                .padding(.bottom, 2)
                
                Text("Reading Volume: \(libraryItem.readingVolume.map { "\($0)" } ?? "-")")
                    .font(.footnote)
                    .foregroundColor(.primary)
//                    .padding(.bottom, 2)
                
                HStack {
                    Text(libraryItem.completeCollection ? "Complete" : "Incomplete")
                    
                    let volumes = mangaItem?.volumes ?? 0
                    Text("(\(libraryItem.volumesOwned.count)/\(volumes > 0 ? "\(volumes)" : "??"))")
                }
//                .font(.callout)
                .font(.subheadline)
                .foregroundColor(libraryItem.completeCollection ? .green : .red)
//                .padding(.bottom, 2)
                
//                Text(libraryItem.volumesOwned.sorted(by: <).map { String($0) }.formatted(.list(type: .and)))
//                    .font(.caption)
//                    .foregroundColor(.secondary)
                
//                Text("Reading Volume: \(libraryItem.readingVolume.map { "\($0)" } ?? "-")")
//                    .font(.caption)
//                    .foregroundColor(.primary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.gray.opacity(0.2)))
        .cornerRadius(10)
        .sheet(isPresented: $isFormPresented) {
            if let manga = mangaItem {
                CollectionManagementView(mangaItem: manga)
            }
        }
    }
}

#Preview("Info del Maga disponible de la API") {
//    @Previewable @Environment(MangaViewModel.self) var model
//    @Previewable @State var imageModel = AsyncImageViewModel()
    
    LibraryItemCellView(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: .test)
//    .modelContainer(for: LibraryItemDB.self, inMemory: true)
//    .environment(model)
//    .environment(imageModel)
}

#Preview("Info del Maga NO disponible ...") {
    LibraryItemCellView(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: nil)
}
