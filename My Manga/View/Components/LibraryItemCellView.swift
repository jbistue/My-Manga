//
//  LibraryItemCellView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/7/25.
//

import SwiftUI

struct LibraryItemCellView: View {
    @State private var isFormPresented: Bool = false
    
    let libraryItem: LibraryItemDB
    let mangaItem: Manga?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
//            cover
//            MangaImageView(url: mangaItem?.mainPicture)
//            MangaImageView(manga: mangaItem)
//                .frame(minHeight: 50, maxHeight: 100, alignment: .center)
//                .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("# \(libraryItem.id)")
                    
                    if let title = mangaItem?.title {
                        Text(title)
                    }
                    
                    Spacer()
                    
                    Button {
                        isFormPresented = true
                    } label: {
//                        Text("···")
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .fontWeight(.light)
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(.white)
//                            .background(
//                                Circle()
//                                    .fill(Color.primary.opacity(0.3))
//                            )
                    }
                }
                .font(.headline)
                
                HStack {
                    Text(libraryItem.completeCollection ? "Completed" : "Not Completed")
                    
                    Text("(\(libraryItem.volumesOwned.count)/\(mangaItem?.volumes ?? 0))")
                }
                .font(.subheadline)
                .foregroundColor(libraryItem.completeCollection ? .green : .red)
                
//                Text(libraryItem.volumesOwned.map { String($0) }.joined(separator: ", "))
                Text(libraryItem.volumesOwned.map { String($0) }.formatted(.list(type: .and)))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(libraryItem.readingVolume.map { "\($0)" } ?? "-")
                    .font(.caption)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.gray.opacity(0.2)))
        .cornerRadius(10)
        .sheet(isPresented: $isFormPresented) {
            CollectionManagementView(libraryItem: libraryItem, mangaItem: mangaItem)
        }
    }
//    @ViewBuilder
//    var cover: some View {
//        if let cover = model.image {
//            Image(uiImage: cover)
//                .resizable()
//                .scaledToFit()
////                .scaledToFill()
//                .cornerRadius(10)
////                .frame(minHeight: 150, maxHeight: 400, alignment: .center)
//                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
//        } else {
//            Image(systemName: "photo")
//                .resizable()
//                .scaledToFit()
//                .padding(100)
////                .frame(minHeight: 150, maxHeight: 400, alignment: .center)
//                .background {
//                    Color.gray.opacity(0.2)
//                }
//                .clipShape(.ellipse)
//                .onAppear {
//                    guard let url = mangaItem?.mainPicture else { return }
//                    model.getImage(from: url)
//                }
//        }
//    }
}

#Preview {
    LibraryItemCellView(
        libraryItem: LibraryItemDB(
            id: 42,
            completedCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: .test)
}
