//
//  CollectionManagementView.swift
//  My Manga
//
//  Created by Javier Bistue on 30/7/25.
//

import SwiftUI

struct CollectionManagementView: View {
//    @Environment(\.dismiss) private var dismiss

    @State private var selectedVolumesToAdd: Set<Int> = []
    @State private var itemSelectedToRead: Int?
    
    let libraryItem: LibraryItemDB
    let mangaItem: Manga?
    
    init(libraryItem: LibraryItemDB, mangaItem: Manga?) {
        self.libraryItem = libraryItem
        self.mangaItem = mangaItem
        _itemSelectedToRead = State(initialValue: libraryItem.readingVolume)
    }
    
    var totalVolumes: [Int] {
        guard let manga = mangaItem else { return [] }
        return Array(1...manga.volumes!)
    }
    
    var pendingVolumes: [Int] {
        guard let manga = mangaItem else { return [] }
        
        let totalVolumes = Set(1...manga.volumes!)
        let ownedVolumes = Set(libraryItem.volumesOwned)
        let pendingVolumes = Array(totalVolumes.subtracting(ownedVolumes)).sorted(by: <)
        return pendingVolumes
    }
    
    var allSelected: Bool {
        selectedVolumesToAdd.count == (mangaItem?.volumes ?? 0) - libraryItem.volumesOwned.count
    }
    
    var body: some View {
        ScrollView {
            if mangaItem != nil {
                
                MangaImageView(url: mangaItem?.mainPicture)
                    .scaledToFill()
                    .frame(height: 350, alignment: .top)
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
                        .padding(.bottom, 16)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("**\((mangaItem?.score ?? 0.00), specifier: "%.2f")**")
                        
                    }
                    .padding(.bottom, 4)
                    
                    HStack {
                        Image(systemName: "bookmark.fill")
                        Text(libraryItem.completeCollection ? "Completed" : "Not Completed")
                        if libraryItem.completeCollection {
                            Text("(\(libraryItem.volumesOwned.count) volumes)")
                        } else {
                            Text("(\(libraryItem.volumesOwned.count) of \(mangaItem?.volumes ?? 0) volumes)")
                        }
                    }
                    .foregroundColor(libraryItem.completeCollection ? .green : .red)
                    .padding(.bottom, 16)
                    
                    Text(mangaItem?.sypnosis ?? "No synopsis available")
                        .font(.callout)
                        .italic()
                        .foregroundColor(.secondary)
                        .lineLimit(4)
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
                    
                    Text("**Authors:** \(mangaItem?.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.formatted(.list(type: .and)) ?? "")")
                        .font(.callout)
                        .padding(.bottom, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                groupBox
            }
//                .scrollIndicators(.hidden)
//                .ignoresSafeArea(.all)
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if mangaItem == nil {
                ContentUnavailableView {
                    Image(systemName: "exclamationmark.triangle")
                } description: {
                    Text(String(localized: "No Manga data available."))
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    var groupBox: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
//                Text("**Pending volumes:** \(pendingVolumes.map { String($0) }.formatted(.list(type: .and)))")
//                    .font(.callout)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.bottom, 10)
//                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("**Select volumes to add:**")
                            .font(.callout)
                        
                        if pendingVolumes.isEmpty {
                            Text("All volumes owned")
                                .foregroundColor(.green)
                        } else {
                            Spacer()
                            
                            Button(allSelected ? "Deselect All" : "Select All") {
                                withAnimation {
                                    if allSelected {
                                        selectedVolumesToAdd.removeAll()
                                    } else {
                                        selectedVolumesToAdd = Set(pendingVolumes)
                                    }
                                }
                            }
                            .font(.subheadline)
                            .padding(6)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(6)
                        }
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 35))], spacing: 10) {
                        ForEach(pendingVolumes, id: \.self) { volume in
                            Button(action: {
                                if selectedVolumesToAdd.contains(volume) {
                                    selectedVolumesToAdd.remove(volume)
                                } else {
                                    selectedVolumesToAdd.insert(volume)
                                }
                            }) {
                                Text("\(volume)")
                                    .font(.caption)
                                    .frame(width: 35, height: 35)
                                    .background(selectedVolumesToAdd.contains(volume) ? Color.accentColor : Color(.systemGray5))
                                    .foregroundColor(selectedVolumesToAdd.contains(volume) ? .white : .primary)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(Color.accentColor, lineWidth: selectedVolumesToAdd.contains(volume) ? 0 : 1)
                                    )
                            }
                            .animation(.easeInOut(duration: 0.2), value: selectedVolumesToAdd)
                        }
                    }
                }
                
                HStack {
                    Text("Reading volume:")
                    Text(libraryItem.readingVolume.map { "\($0)" } ?? "-")
                        .foregroundColor(.accentColor)
                }
                
                HStack {
                    Text("**Reading volume:**")
                        .font(.callout)
                    
                    Picker("Reading volume:", selection: $itemSelectedToRead) {
                        Text("-").tag(Optional<Int>.none)
                        ForEach(libraryItem.volumesOwned, id: \.self) { item in
                            Text(String(item))
                                .tag(item)
                                .font(.callout)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80)
                    
                    Button {
                        itemSelectedToRead = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .fontWeight(.light)
                    }
                    
                    Button {
                        guard let current = itemSelectedToRead,
                              let index = libraryItem.volumesOwned.firstIndex(of: current),
                              libraryItem.volumesOwned.indices.contains(index + 1)
                        else {
                            itemSelectedToRead = libraryItem.volumesOwned.first
                            return
                        }
                        itemSelectedToRead = libraryItem.volumesOwned[index + 1]
                    } label: {
                        Image(systemName: "chevron.forward.circle")
                            .font(.title2)
                            .fontWeight(.light)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
        //        Text("Selected: \(selectedItem ?? "None")")
                Text("**Selected:** \(itemSelectedToRead ?? 0)")
                    .font(.callout)
            }
        }
        
    }
}

#Preview("En Librería y con detalles") {
    CollectionManagementView(
        libraryItem: LibraryItemDB(
            id: 42,
            completedCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: .test)
}

#Preview("En Librería y sin detalles") {
    CollectionManagementView(
        libraryItem: LibraryItemDB(
            id: 42,
            completedCollection: false,
            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
            readingVolume: 4),
        mangaItem: nil)
}
