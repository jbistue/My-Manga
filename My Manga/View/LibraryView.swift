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
    
    @Query private var mangas: [LibraryItemDB]
    
    @State private var detailsDict: [Int: Manga] = [:]
    @State private var selectedCollectionStatus: CollectionStatus = .reading
    @State private var previousStatus: CollectionStatus = .reading
   
    @Namespace private var namespace
    @Namespace private var segmentedControl
    
    var transitionEdge: Edge {
        if previousStatus == .reading && selectedCollectionStatus == .complete {
            return .trailing
        } else if previousStatus == .complete && selectedCollectionStatus == .reading {
            return .leading
        } else if selectedCollectionStatus == .reading {
            return .leading
        } else {
            return .trailing
        }
    }
  
    var body: some View {
        NavigationStack {
            VStack {
                if selectedCollectionStatus == .reading {
                    LibraryItemsView(predicate: #Predicate { $0.readingVolume != nil }, namespace: namespace)
                        .transition(.move(edge: .leading))
//                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if selectedCollectionStatus == .complete {
                    LibraryItemsView(predicate: #Predicate { $0.completeCollection }, namespace: namespace)
//                        .transition(.move(edge: .trailing))
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else {
                    LibraryItemsView(predicate: #Predicate { !$0.completeCollection }, namespace: namespace)
                        .transition(.move(edge: .trailing))
//                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
                
                HStack {
                    ForEach(CollectionStatus.allCases) { type in
                        Button {
                            previousStatus = selectedCollectionStatus
                            selectedCollectionStatus = type
                        } label: {
                            Text(type.rawValue)
                                .font(.subheadline)
                                .padding(6)
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
                .background(.secondary.opacity(0.3))
                .clipShape(.capsule)
                .buttonStyle(.plain)
            }
            .safeAreaPadding()
            .animation(.easeInOut, value: selectedCollectionStatus)
            .navigationTitle(Text("Library"))
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
    }
}

#Preview(traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    
    LibraryView()
        .environment(model)
}
