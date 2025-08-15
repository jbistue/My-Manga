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
    @Environment(\.dismiss) private var dismiss
    
    @State private var libraryItem: LibraryItemDB? = nil
    @State private var selectedVolumesToAdd: Set<Int> = []
    @State private var itemSelectedToRead: Int? = nil
    
    let mangaItem: Manga
    
    private var pendingVolumes: [Int] {
        guard let volumes = mangaItem.volumes else { return [] }
        
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
            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Text(mangaItem.title ?? "Unknown Manga")
                        .font(.title)
                        .foregroundColor(.primary)
                        .bold()
                        .padding(.vertical, 16)

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
            // TODO: este formato de botón se usa en tres sitios, quizás convendría crear un estilo de botón personalizado
                                .buttonStyle(.bordered)
                                .font(.subheadline)
    //                            .font(.subheadline)
    //                            .padding(6)
    //                            .background(Color.accentColor.opacity(0.1))
    //                            .foregroundColor(.accentColor)
    //                            .cornerRadius(6)
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
                    
                    if libraryItem != nil {
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
                            
                            Button("Next") {
                                withAnimation {
                                    guard let current = itemSelectedToRead,
                                          let index = libraryItem?.volumesOwned.firstIndex(of: current),
                                          ((libraryItem?.volumesOwned.indices.contains(index + 1)) != nil)
                                    else {
                                        itemSelectedToRead = libraryItem?.volumesOwned.first
                                        return
                                    }
                                    itemSelectedToRead = libraryItem?.volumesOwned[index + 1]
                                }
                            }
                            .buttonStyle(.bordered)
                            .font(.subheadline)
    //                        .padding(6)
    //                        .background(Color.accentColor.opacity(0.1))
    //                        .foregroundColor(.accentColor)
    //                        .cornerRadius(6)

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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
    //                    Button("Cancel", role: .cancel) {
    //                        dismiss()
    //                    }
    //                    .buttonStyle(.bordered)
                        
                        Button("Save") {
                            updateLibrary()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            // TODO: eliminar este texto, está solo a efecto de pruebas y comprobaciones
//            Text("Id item biblioteca: \(libraryItem?.id ?? 0)")
//            Text("Id manga a buscar: \(mangaItem.id)")
//            
//            if libraryItem != nil {
//                Text("Reading volume: \(libraryItem?.readingVolume.map { "\($0)" } ?? "-")")
//                Text("Selected: \(itemSelectedToRead ?? 0)")
//            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            print("Library Item ID (al cargar):", libraryItem?.id ?? "No Library Item")
            loadItem()
        }
    }
    
    private func loadItem() {
        print("Loading item with ID (función): \(mangaItem.id)")
        let descriptor = FetchDescriptor<LibraryItemDB>(
            predicate: #Predicate { $0.id == mangaItem.id }
        )
            
        do {
            let results = try modelContext.fetch(descriptor)
            libraryItem = results.first
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

#Preview("En Biblioteca, con info API", traits: .sampleData) {
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

#Preview("No en Biblioteca") {
    CollectionManagementView(
        mangaItem: .test)
}
