//
//  LibraryDetailView.swift
//  My Manga
//
//  Created by Javier Bistue on 7/8/25.
//

import SwiftUI

struct LibraryDetailView: View {
    @State private var isFormPresented: Bool = false
    
    let libraryItem: LibraryItemDB
    let mangaItem: Manga?
    
    private let screenHeight = UIScreen.main.bounds.height
        
    private var pendingVolumes: [Int] {
        guard let volumes = mangaItem?.volumes else { return [] }
        
        let totalVolumes = Set(1...volumes)
        
        let ownedVolumes = Set(libraryItem.volumesOwned)
        let pendingVolumes = Array(totalVolumes.subtracting(ownedVolumes)).sorted(by: <)
        return pendingVolumes
    }
        
    var body: some View {
        if mangaItem != nil {
            ScrollView {
                MangaImageView(url: mangaItem?.mainPicture)
                    .id(mangaItem?.mainPicture)
                    .cornerRadius(10)
                    .frame(minHeight: 150, maxHeight: 400, alignment: .center)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
                    .padding(.vertical, 16)
                
                VStack(alignment: .leading) {
                    Text(mangaItem?.title ?? "Unknown Manga")
                        .font(.title)
                        .bold()
                        .padding(.top, 16)
                    
                    Text("\(mangaItem?.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.formatted(.list(type: .and)) ?? "")")
                        .font(.callout)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("**\((mangaItem?.score ?? 0.00), specifier: "%.2f")**")
                        
                    }
                    .padding(.bottom, 4)
                    
                    HStack {
                        Image(systemName: libraryItem.readingVolume == nil ? "bookmark.slash.fill" : "bookmark.fill")
                        Text("Reading Volume: \(libraryItem.readingVolume.map { "\($0)" } ?? "-")")
                    }
                    .foregroundColor(libraryItem.readingVolume == nil ? .red : .accentColor)
                    .padding(.bottom, 4)
                    
                    HStack {
                        Image(systemName: "books.vertical.fill")
                        Text(libraryItem.completeCollection ? "Complete" : "Incomplete")
                        if libraryItem.completeCollection {
                            Text("(\(libraryItem.volumesOwned.count) volumes)")
                        } else {
                            Text("(\(libraryItem.volumesOwned.count) of \(mangaItem?.volumes ?? 0) volumes)")
                        }
                    }
                    .foregroundColor(libraryItem.completeCollection ? .green : .red)
                    .padding(.bottom, pendingVolumes.isEmpty ? 16 : 0)
                    
                    if !pendingVolumes.isEmpty {
                        HStack {
                            Image(systemName: "books.vertical.fill")
                                .opacity(0)
                            Text("Pending: \(pendingVolumes.map { "\($0)" }.formatted(.list(type: .and)))")
                                .font(.footnote)
                                .italic()
                                .foregroundColor(.red)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    Text(mangaItem?.sypnosis ?? String(localized:"No synopsis available"))
                        .font(.callout)
                        .italic()
                        .foregroundColor(.secondary)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 8)
                    
                    Text("**Themes:** \(mangaItem?.themes.map { $0.theme }.formatted(.list(type: .and)) ?? "")")
                        .font(.callout)
                        .padding(.bottom, 2)
                    
                    Text("**Genres:** \(mangaItem?.genres.map { $0.genre }.formatted(.list(type: .and)) ?? "")")
                        .font(.callout)
                        .padding(.bottom, 2)
                    
                    Text("**Demographics:** \(mangaItem?.demographics.map { $0.demographic }.formatted(.list(type: .and)) ?? "")")
                        .font(.callout)
                        .padding(.bottom, 2)
                    
                    Link("\(mangaItem?.url?.absoluteString ?? "-")", destination: mangaItem?.url ?? URL(string: "")!)
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if mangaItem != nil {
                                isFormPresented = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                                .fontWeight(.light)
                        }
                    }
                }
                .sheet(isPresented: $isFormPresented) {
                    LibraryManagementView(mangaItem: mangaItem!)
                }
            }
            .scrollIndicators(.hidden)
        } else {
            ContentUnavailableView {
                Image(systemName: "exclamationmark.triangle")
            } description: {
                Text(String(localized: "Manga data not available."))
            }
        }
    }
}

#Preview {
    LibraryDetailView(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: .test)
}

#Preview {
    LibraryDetailView(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: nil)
}
