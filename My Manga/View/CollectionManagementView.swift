//
//  CollectionManagementView.swift
//  My Manga
//
//  Created by Javier Bistue on 30/7/25.
//

import SwiftUI
import SwiftData

struct CollectionManagementView: View {
    @Environment(\.modelContext) private var modelContext
//    @Environment(AsyncImageViewModel.self) private var imageModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var libraryItem: LibraryItemDB? = nil
    @State private var selectedVolumesToAdd: Set<Int> = []
    @State private var itemSelectedToRead: Int? = nil
    
    let mangaItem: Manga
    
    var pendingVolumes: [Int] {
        guard let volumes = mangaItem.volumes else {
            print("Volúmenes es nil")
            return []
        }
        
        let totalVolumes = Set(1...volumes)
        
        guard let mangaInLibrary = libraryItem else { return Array(totalVolumes).sorted(by: <) }
        
        let ownedVolumes = Set(mangaInLibrary.volumesOwned)
        let pendingVolumes = Array(totalVolumes.subtracting(ownedVolumes)).sorted(by: <)
        return pendingVolumes
    }
    
    var allSelected: Bool {
        selectedVolumesToAdd.count == (mangaItem.volumes ?? 0) - (libraryItem?.volumesOwned.count ?? 0)
    }
    
    var body: some View {
        ScrollView {
//            if mangaItem != nil {
                
//                MangaImageView(url: mangaItem?.mainPicture)
//                    .scaledToFill()
//                    .frame(height: 350, alignment: .top)
//                    .clipped()
//                    .frame(maxWidth: .infinity)
//                    .overlay(
//                        LinearGradient(
//                            gradient: Gradient(stops: [
//                                .init(color: .clear, location: 0.0),
//                                .init(color: Color(.systemBackground).opacity(0.5), location: 0.7),
//                                .init(color: Color(.systemBackground).opacity(1.0), location: 1.0)
//                            ]),
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                    )
                
                VStack(alignment: .leading) {
//                    Text(mangaItem?.title ?? "Unknown Manga")
                    Text(mangaItem.title ?? "Unknown Manga")
                        .font(.title)
                        .bold()
                        .padding(.vertical, 16)
                    
//                    HStack {
//                        Image(systemName: "star.fill")
//                            .foregroundColor(.yellow)
//                        Text("**\((mangaItem?.score ?? 0.00), specifier: "%.2f")**")
//                        
//                    }
//                    .padding(.bottom, 4)
//                    
//                    HStack {
//                        Image(systemName: "bookmark.fill")
//                        Text(libraryItem?.completeCollection ?? false ? "Complete" : "Incomplete")
//                        if libraryItem?.completeCollection ?? false {
//                            Text("(\(libraryItem?.volumesOwned.count ?? mangaItem?.volumes ?? 0) volumes)")
//                        } else {
//                            Text("(\(libraryItem?.volumesOwned.count ?? 0) of \(mangaItem?.volumes ?? 0) volumes)")
//                        }
//                    }
//                    .foregroundColor(libraryItem?.completeCollection ?? false ? .green : .red)
//                    .padding(.bottom, 16)
                    
//                    Text(mangaItem?.sypnosis ?? String(localized:"No synopsis available"))
//                        .font(.callout)
//                        .italic()
//                        .foregroundColor(.secondary)
//                        .lineLimit(4)
//                        .truncationMode(.tail)
//                        .multilineTextAlignment(.leading)
//                        .padding(.bottom, 8)
//                    
//                    Text("**Themes:** \(mangaItem?.themes.map { $0.theme }.formatted(.list(type: .and)) ?? "")")
//                        .font(.callout)
//                        .padding(.bottom, 2)
//                    
//                    Text("**Genres:** \(mangaItem?.genres.map { $0.genre }.formatted(.list(type: .and)) ?? "")")
//                        .font(.callout)
//                        .padding(.bottom, 2)
//                    
//                    Text("**Demographics:** \(mangaItem?.demographics.map { $0.demographic }.formatted(.list(type: .and)) ?? "")")
//                        .font(.callout)
//                        .padding(.bottom, 2)
//                    
//                    Text("**Authors:** \(mangaItem?.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.formatted(.list(type: .and)) ?? "")")
//                        .font(.callout)
//                        .padding(.bottom, 2)
                }
//                .onAppear {
//                    print("Library Item ID:", libraryItem?.id ?? "No Library Item")
//                    loadItem()
//                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
            Text(String(libraryItem?.id ?? 0) + " - \(mangaItem.id)")
                    
                groupBox
//                .onAppear() {
//                    print(libraryItem?.id ?? "No Library Item")
//                }
//            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            print("Library Item ID (al cargar):", libraryItem?.id ?? "No Library Item")
            loadItem()
        }

//        .ignoresSafeArea(.all)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onAppear() {
//            print(libraryItem?.id ?? "No Library Item")
//        }
//        .overlay {
//            if mangaItem == nil {
//                ContentUnavailableView {
//                    Image(systemName: "exclamationmark.triangle")
//                } description: {
//                    Text(String(localized: "No Manga data available."))
//                }
//            }
//        }
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
                            Text(String(localized: "All volumes owned"))
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
                
// TODO: Eliminar este texto, está solo a efecto de pruebas
                if libraryItem != nil {
                    
                    Text("Reading volume: \(libraryItem?.readingVolume.map { "\($0)" } ?? "-")")
                    Text("**Selected:** \(itemSelectedToRead ?? 0)")
                    
                    HStack {
                        Text("**Reading volume:**")
                            .font(.callout)
                        
                        Picker("Reading volume:", selection: $itemSelectedToRead) {
                            Text("-").tag(Optional<Int>.none)
                            if let mangasInLibrary = libraryItem{
                                ForEach(mangasInLibrary.volumesOwned.sorted(by: <), id: \.self) { item in
                                    Text(String(item))
                                        .tag(item)
                                        .font(.callout)
                                }
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80)
                        
                        Button("None") {
                            withAnimation {
                                itemSelectedToRead = nil
                            }
                        }
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.accentColor.opacity(0.1))
                        .foregroundColor(.accentColor)
                        .cornerRadius(6)
                        //                    Button {
                        //                        itemSelectedToRead = nil
                        //                    } label: {
                        //                        Image(systemName: "xmark.circle")
                        //                            .font(.title2)
                        //                            .fontWeight(.light)
                        //                    }
                        //MARK: botón para pasar a leer el siguiente volumen, no creo que haga falta (resolver libraryItem nil)
                        //                    Button {
                        //                        guard let current = itemSelectedToRead,
                        //                              let index = libraryItem.volumesOwned.firstIndex(of: current),
                        //                              libraryItem.volumesOwned.indices.contains(index + 1)
                        //                        else {
                        //                            itemSelectedToRead = libraryItem.volumesOwned.first
                        //                            return
                        //                        }
                        //                        itemSelectedToRead = libraryItem.volumesOwned[index + 1]
                        //                    } label: {
                        //                        Image(systemName: "chevron.forward.circle")
                        //                            .font(.title2)
                        //                            .fontWeight(.light)
                        //                    }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    updateLibrary()
                    dismiss()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .center)
            }
//            .onAppear {
//                print("Library Item ID:", libraryItem?.id ?? "No Library Item")
//                loadItem()
//            }
        }
    }
    
    private func loadItem() {
        print("Loading item with ID (función): \(mangaItem.id)")
        let descriptor = FetchDescriptor<LibraryItemDB>(
            predicate: #Predicate { $0.id == mangaItem.id }
        )
            
        do {
            let results = try modelContext.fetch(descriptor)
            libraryItem = results.first // Será nil si no se encuentra
            itemSelectedToRead = libraryItem?.readingVolume
            print("Library item: \(libraryItem?.id ?? 0)")
        } catch {
            print("Database search error: \(error)")
        }
    }
    
    private func updateLibrary() {
        let updatedVolumesOwned = (libraryItem?.volumesOwned ?? []) + Array(selectedVolumesToAdd)
        let updatedCompleteCollection = mangaItem.volumes == updatedVolumesOwned.count
        let updatedReadingVolume = itemSelectedToRead
        
        if let existingItem = libraryItem {
            print("Updating existing library item with ID: \(existingItem.id)")
            existingItem.volumesOwned = updatedVolumesOwned
            existingItem.completeCollection = updatedCompleteCollection
            existingItem.readingVolume = updatedReadingVolume
            
            do {
                try modelContext.save()
            } catch {
                print("Error saving item: \(error)")
            }
        } else {
            print("Creating new library item for manga with ID: \(mangaItem.id)")
            let newItem = LibraryItemDB(
                id: mangaItem.id,
                completeCollection: updatedCompleteCollection,
                volumesOwned: updatedVolumesOwned,
                readingVolume: updatedReadingVolume
            )
            modelContext.insert(newItem)
        }
    }
}

#Preview("En Librería, con info API", traits: .sampleData) {
    CollectionManagementView(
        mangaItem: .testInLibrary)
}

//#Preview("En Librería, sin info API") {
//    @Previewable @State var imageModel = AsyncImageViewModel()
//    
//    CollectionManagementView(
//        mangaItem: nil,
//        libraryItem: LibraryItemDB(
//            id: 42,
//            completeCollection: false,
//            volumesOwned: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38],
//            readingVolume: 4))
//    .environment(imageModel)
//}

#Preview("No en Librería") {
    CollectionManagementView(
        mangaItem: .test)
}
