//
//  LibraryView.swift
//  My Manga
//
//  Created by Javier Bistue on 7/7/25.
//

import SwiftUI
import SwiftData

enum CollectionStatus: LocalizedStringResource, CaseIterable, Identifiable {
    case reading = "Reading"
    case complete = "Complete"
    case incomplete = "Incomplete"
    
    var id: Self { self }
}

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
    
//    @Query private var libraryItems: [LibraryItemDB]
    @Query private var mangas: [LibraryItemDB]
    
//    @State private var mangas: [LibraryItem] = []
    @State private var detailsDict: [Int: Manga] = [:]
    @State private var selectedCollectionStatus: CollectionStatus = .reading
   
    @Namespace private var namespace
    @Namespace private var segmentedControl
    
//    var mangasFiltered: [LibraryItem] {
    var mangasFiltered: [LibraryItemDB] {
        switch selectedCollectionStatus {
        case .reading:
            return mangas.filter { $0.readingVolume != nil }
        case .complete:
            return mangas.filter { $0.completeCollection }
        case .incomplete:
            return mangas.filter { !$0.completeCollection }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(mangasFiltered) { manga in
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
                //.safeAreaPadding()
                .animation(.easeInOut, value: selectedCollectionStatus)
                //.navigationTitle(Text(selectedMovieType.rawValue))
            }
            //.navigationTitle(Text(selectedCollectionStatus.rawValue))
            .navigationTitle(Text("Library"))
            //.padding(.bottom, 10)
            
            HStack {
                ForEach(CollectionStatus.allCases) { type in
                    Button {
                        selectedCollectionStatus = type
                    } label: {
                        Text(type.rawValue)
                            .font(.subheadline)
                            .padding(6)
                            //.padding(16)
                    }
                    .matchedGeometryEffect(id: type, in: segmentedControl)
                }
            }
            .background(
                Capsule()
                    .fill(.background.tertiary)
                    .matchedGeometryEffect(id: selectedCollectionStatus, in: segmentedControl, isSource: false)
            )
            .padding(4)
            //.padding(14)
            .background(.secondary.opacity(0.3))
            .clipShape(.capsule)
            .buttonStyle(.plain)
        }
//        .onAppear {
//            mangas = loadLibraryItems()
//        }
        .overlay {
            if mangas.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.slash")
                } description: {
                    Text(String(localized: "There is no Manga in the library."))
                }
            }
        }
        //.padding(.bottom, 16)
        //.background(Color.blue.opacity(0.03))
    }
}

#Preview(traits: .sampleData) {
//#Preview() {
    @Previewable @State var model = MangaViewModel()
    
    LibraryView()
        .environment(model)
//        .modelContainer(for: LibraryItemDB.self, inMemory: true)
}
