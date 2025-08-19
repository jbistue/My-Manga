//
//  LibraryRow.swift
//  My Manga
//
//  Created by Javier Bistue on 16/7/25.
//

import SwiftUI

struct LibraryRow: View {
    @State private var isFormPresented: Bool = false
    
    let libraryItem: LibraryItemDB
    let mangaItem: Manga?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            MangaImageView(url: mangaItem?.mainPicture)
                .cornerRadius(10)
//                .frame(maxWidth: 60, minHeight: 50, maxHeight: 90, alignment: .center)
                .frame(maxWidth: 60, maxHeight: 90, alignment: .center)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
            
            VStack(alignment: .leading) {
                HStack {
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
                            .foregroundColor(.secondary)
                            .fontWeight(.light)
                    }
                    .disabled(mangaItem == nil)
                }
                .font(.headline)
                .padding(.bottom, 2)
                
                Text("Reading Volume: \(libraryItem.readingVolume.map { "\($0)" } ?? "-")")
                    .font(.footnote)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(libraryItem.completeCollection ? "Complete" : "Incomplete")
                    
                    let volumes = mangaItem?.volumes ?? 0
                    Text("(\(libraryItem.volumesOwned.count)/\(volumes > 0 ? "\(volumes)" : "??"))")
                }
                .font(.subheadline)
                .foregroundColor(libraryItem.completeCollection ? .green : .red)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .sheet(isPresented: $isFormPresented) {
            if let manga = mangaItem {
                LibraryManagementView(mangaItem: manga)
            }
        }
    }
}

#Preview("Info del Maga disponible de la API") {
    LibraryRow(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: .test)
}

#Preview("Info del Maga NO disponible ...") {
    LibraryRow(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: nil)
}
