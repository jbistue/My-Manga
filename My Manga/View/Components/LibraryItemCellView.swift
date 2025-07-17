//
//  LibraryItemCellView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/7/25.
//

import SwiftUI

struct LibraryItemCellView: View {
    @Environment(MangaViewModel.self) var model
    
    @State private var detailsDict: [Int: Manga] = [:]
    
    let manga: LibraryItemDB
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("# \(manga.id)")
                
                if let title = detailsDict[manga.id]?.title {
                    Text(title)
                }
            }
            .font(.headline)
            
            HStack {
                Text(manga.completeCollection ? "Completed" : "Not Completed")
                
                Text("(\(manga.volumesOwned.count)/\(detailsDict[manga.id]?.volumes ?? 0))")
            }
            .font(.subheadline)
            .foregroundColor(manga.completeCollection ? .green : .red)
            
            Text(manga.volumesOwned.map { String($0) }.joined(separator: ", "))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(manga.readingVolume.map { "\($0)" } ?? "-")
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.gray.opacity(0.2)))
        .cornerRadius(10)
        .task {
            await model.getMangaDetail(id: manga.id)
            detailsDict[manga.id] = model.manga
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    LibraryItemCellView(manga: LibraryItemDB(
        id: 22,
        completedCollection: false,
        volumesOwned: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25],
        readingVolume: 2))
        .environment(model)
}
