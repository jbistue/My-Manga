//
//  LibraryManagementView.swift
//  My Manga
//
//  Created by Javier Bistue on 30/7/25.
//

import SwiftUI
import SwiftData

struct LibraryManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var libraryItem: LibraryItemDB? = nil
    @State private var selectedVolumesToAdd: Set<Int> = []
    @State private var itemSelectedToRead: Int? = nil
    @State private var hasChangedVolumesToAdd = false
    @State private var hasChangedVolumeToRead = false
    @State private var showDeleteConfirmation = false
    
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
            VStack(alignment: .leading, spacing: 16) {
                Text(mangaItem.title ?? "Unknown Manga")
                    .font(.title)
                    .foregroundColor(.primary)
                    .bold()
                    .padding(.vertical, 16)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .bottom) {
                        Text("**Select volumes to add:**")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        if pendingVolumes.isEmpty {
                            Text(String(localized: "All volumes owned"))
                                .foregroundColor(.green)
                                .multilineTextAlignment(.trailing)
                        } else {
                            Button(allSelected ? "Deselect All" : "Select All") {
                                withAnimation {
                                    if allSelected {
                                        selectedVolumesToAdd.removeAll()
                                        hasChangedVolumesToAdd = false
                                    } else {
                                        selectedVolumesToAdd = Set(pendingVolumes)
                                        hasChangedVolumesToAdd = true
                                    }
                                }
                            }
                            .font(.subheadline)
                        }
                    }
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 35))], spacing: 10) {
                        ForEach(pendingVolumes, id: \.self) { volume in
                            Button(action: {
                                if selectedVolumesToAdd.contains(volume) {
                                    selectedVolumesToAdd.remove(volume)
                                    if selectedVolumesToAdd.isEmpty {
                                        hasChangedVolumesToAdd = false
                                    }
                                } else {
                                    selectedVolumesToAdd.insert(volume)
                                    hasChangedVolumesToAdd = true
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
                    let initialReadingVolume = libraryItem?.readingVolume ?? nil
                    
                    HStack {
                        Text("**Reading volume:**")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
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
                        .onChange(of: itemSelectedToRead) { _, newValue in
                            hasChangedVolumeToRead = newValue != initialReadingVolume
                        }
                        
                        Button("Next") {
                            withAnimation {
                                guard
                                    let volumes = libraryItem?.volumesOwned.sorted()
                                else { return }
                                
                                if let current = itemSelectedToRead,
                                   let index = volumes.firstIndex(of: current),
                                   index < volumes.count - 1 {
                                    itemSelectedToRead = volumes[index + 1]
                                } else {
                                    itemSelectedToRead = volumes.first
                                }
                            }
                        }
                        .font(.subheadline)
                        .disabled({
                            guard
                                let volumes = libraryItem?.volumesOwned.sorted()
                            else { return true }
                            
                            if let current = itemSelectedToRead,
                               let index = volumes.firstIndex(of: current) {
                                return index == volumes.count - 1 // último -> desactivar
                            }
                            return false
                        }())
                        
                        Button("None") {
                            withAnimation {
                                itemSelectedToRead = nil
                            }
                        }
                        .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    Button("Remove from Library", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(libraryItem == nil)
                    
                    Button("Done") {
                        updateLibrary()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!hasChangedVolumesToAdd && !hasChangedVolumeToRead)
                    .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                        Button("Delete", role: .destructive) {
                            guard let itemToDelete = libraryItem else { return }
                            modelContext.delete(itemToDelete)
                            do {
                                try modelContext.save()
                            } catch {
                                print("Error deleting manga: \(error.localizedDescription)")
                            }
                            dismiss()
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This Manga will be permanently removed from your library.")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .onAppear {
            loadItem()
        }
    }
    
    private func loadItem() {
        let descriptor = FetchDescriptor<LibraryItemDB>(
            predicate: #Predicate { $0.id == mangaItem.id }
        )
            
        do {
            let results = try modelContext.fetch(descriptor)
            libraryItem = results.first
            itemSelectedToRead = libraryItem?.readingVolume
        } catch {
            print("Database search error: \(error)")
        }
    }
    
    private func updateLibrary() {
        let updatedVolumesOwned = (libraryItem?.volumesOwned ?? []) + Array(selectedVolumesToAdd)
        let updatedCompleteCollection = mangaItem.volumes == updatedVolumesOwned.count
        let updatedReadingVolume = itemSelectedToRead
        
        if let existingItem = libraryItem {
            existingItem.volumesOwned = updatedVolumesOwned
            existingItem.completeCollection = updatedCompleteCollection
            existingItem.readingVolume = updatedReadingVolume
            
            do {
                try modelContext.save()
            } catch {
                print("Error saving item: \(error)")
            }
        } else {
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
    LibraryManagementView(
        mangaItem: .testInLibrary)
}

#Preview("No en Biblioteca") {
    LibraryManagementView(
        mangaItem: .test)
}
