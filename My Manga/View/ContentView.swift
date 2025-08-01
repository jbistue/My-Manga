//
//  ContentView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(MangaViewModel.self) var model
    
    @Namespace private var namespace

    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical.fill") {
                LibraryView2()
                    .navigationBarTitle("Library")
            }
            
            Tab("Store", systemImage: "bag.fill") {
                StoreView(namespace: namespace)
//                MangaListView()
                    .navigationBarTitle("Store")
            }
            
//            Tab("Authors", systemImage: "person.2.fill") {
//                AuthorsView()
//                    .navigationBarTitle("Authors")
//            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    
    ContentView()
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
//        .modelContainer(for: Item.self, inMemory: true)
}
