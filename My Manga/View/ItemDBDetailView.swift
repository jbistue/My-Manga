//
//  ItemDBDetailView.swift
//  My Manga
//
//  Created by Javier Bistue on 7/8/25.
//

import SwiftUI

struct ItemDBDetailView: View {
//    var body: some View {
//        @Environment(\.modelContext) private var modelContext
//    //    @Environment(AsyncImageViewModel.self) private var imageModel
//        @Environment(\.dismiss) private var dismiss
//        
//        @State private var libraryItem: LibraryItemDB? = nil
//        @State private var selectedVolumesToAdd: Set<Int> = []
//        @State private var itemSelectedToRead: Int? = nil
//        
//        let mangaItem: Manga
    let libraryItem: LibraryItemDB
    let mangaItem: Manga?
    
    private let screenHeight = UIScreen.main.bounds.height
        
//        var pendingVolumes: [Int] {
//            guard let volumes = mangaItem?.volumes else {
//                print("Volúmenes es nil")
//                return []
//            }
//            
//            let totalVolumes = Set(1...volumes)
//            
//            guard let mangaInLibrary = libraryItem else { return Array(totalVolumes).sorted(by: <) }
//            
//            let ownedVolumes = Set(mangaInLibrary.volumesOwned)
//            let pendingVolumes = Array(totalVolumes.subtracting(ownedVolumes)).sorted(by: <)
//            return pendingVolumes
//        }
//        
//        var allSelected: Bool {
//            selectedVolumesToAdd.count == (mangaItem.volumes ?? 0) - (libraryItem?.volumesOwned.count ?? 0)
//        }
        
        var body: some View {
            ScrollView {
//            if mangaItem != nil {
//                    
                MangaImageView(url: mangaItem?.mainPicture)
                    .id(mangaItem?.mainPicture)
                    .scaledToFill()
//                    .frame(height: 350, alignment: .top)
                    .frame(height: 0.40 * screenHeight, alignment: .top)
                    .clipped()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0.0),
                                .init(color: Color(.systemBackground).opacity(0.5), location: 0.7),
                                .init(color: Color(.systemBackground).opacity(1.0), location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
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
                    .padding(.bottom, 16)
                        
                    Text(mangaItem?.sypnosis ?? String(localized:"No synopsis available"))
                        .font(.callout)
                        .italic()
                        .foregroundColor(.secondary)
//                           .lineLimit(4)
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
//    //                .onAppear {
//    //                    print("Library Item ID:", libraryItem?.id ?? "No Library Item")
//    //                    loadItem()
//    //                }

//                    
//                Text(String(libraryItem?.id ?? 0) + " - \(mangaItem.id)")
//
            }
            .scrollIndicators(.hidden)
////            .onAppear {
////                print("Library Item ID (al cargar):", libraryItem?.id ?? "No Library Item")
////                loadItem()
////            }
//
            .ignoresSafeArea(.all)
//    //        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    //        .onAppear() {
//    //            print(libraryItem?.id ?? "No Library Item")
//    //        }
//    //        .overlay {
//    //            if mangaItem == nil {
//    //                ContentUnavailableView {
//    //                    Image(systemName: "exclamationmark.triangle")
//    //                } description: {
//    //                    Text(String(localized: "No Manga data available."))
//    //                }
//    //            }
    //        }
    }
    
//    private func loadItem() {
//        print("Loading item with ID (función): \(mangaItem.id)")
//        let descriptor = FetchDescriptor<LibraryItemDB>(
//            predicate: #Predicate { $0.id == mangaItem.id }
//        )
//            
//        do {
//            let results = try modelContext.fetch(descriptor)
//            libraryItem = results.first // Será nil si no se encuentra
//            itemSelectedToRead = libraryItem?.readingVolume
//            print("Library item: \(libraryItem?.id ?? 0)")
//        } catch {
//            print("Database search error: \(error)")
//        }
//    }
}

#Preview {
//    @Previewable @State var imageModel = AsyncImageViewModel()
    
    ItemDBDetailView(
        libraryItem: LibraryItemDB(
            id: 42,
            completeCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: .test)
//    .environment(imageModel)
}
