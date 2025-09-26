//
//  LibraryManagementView.swift
//  My Manga
//
//  Created by Javier Bistue on 30/7/25.
//

import SwiftUI
import SwiftData

struct LibraryManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
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
        NavigationStack {
            ScrollView {
                Text(String(localized: "SELECT VOLUMES TO ADD"))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.top, 20)
                
                VStack(alignment: .center) {
                    if pendingVolumes.isEmpty {
                        Text(String(localized: "All volumes owned"))
                            .foregroundColor(.green)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
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
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    
                    Divider()
                    
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
                                    .padding(.horizontal, 10)
                            }
                            .animation(.easeInOut(duration: 0.2), value: selectedVolumesToAdd)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if libraryItem != nil {
                    let initialReadingVolume = libraryItem?.readingVolume ?? nil
                    
                    Text(String(localized: "READING VOLUME"))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        .padding(.top, 10)
                    
                    HStack {
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
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle(mangaItem.title ?? "Unknown Manga")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
            .background(Color(.secondarySystemBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(libraryItem == nil ? .gray.opacity(0.4) : .red)
                    }
                    .disabled(libraryItem == nil)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        updateLibrary()
                        dismiss()
                    }
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
            }
            .onAppear {
                loadItem()
            }
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

#Preview("Colección en Biblioteca", traits: .sampleData) {
    LibraryManagementView(
        mangaItem: .testInLibrary)
}

#Preview("Colección nueva") {
    LibraryManagementView(
        mangaItem: .test)
}
