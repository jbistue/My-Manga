//
//  LibraryView.swift
//  My Manga
//
//  Created by Javier Bistue on 7/7/25.
//

import SwiftUI

struct LibraryView: View {
    @Environment(MangaViewModel.self) var model
    
    @State private var mangas: [LibraryItem] = []
    @State private var detailsDict: [Int: Manga] = [:]
    
    var body: some View {
        NavigationStack {
            List(mangas) { manga in
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
                .task {
                    await model.getMangaDetail(id: manga.id)
                    detailsDict[manga.id] = model.manga
                }
            }
            .navigationTitle(Text("Library"))
        }
        .onAppear {
            mangas = loadLibraryItems()
        }
        .overlay {
            if mangas.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.slash")
                } description: {
                    Text(String(localized: "There is no Manga in the library."))
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    LibraryView()
        .environment(model)
}
