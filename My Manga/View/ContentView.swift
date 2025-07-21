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
    
//    @Query private var items: [Item]

    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical.fill") {
                LibraryView()
                    .navigationBarTitle("Library")
            }
            
            // Tab("Home", systemImage: "house.fill") {
            Tab("Store", systemImage: "bag.fill") {
//                StoreView(namespace: namespace)
                MangaListView()
                    .navigationBarTitle("Store")
            }
            
            // Tab("Search", systemImage: "magnifyingglass", role: .search) {
            Tab("Genres", systemImage: "magnifyingglass") {
                GenresView()
                    .navigationBarTitle("Search")
            }
            
            Tab("Themes", systemImage: "person.2.fill") {
                ThemesView()
                    .navigationBarTitle("Themes")
            }
            
//            Tab("Settings", systemImage: "gear") {
//            Tab("Authors", systemImage: "gear") {
            Tab("Demographics", systemImage: "gear") {
                DemographicsView()
//                AuthorsView()
                    .navigationBarTitle("Settings")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .sampleData) {
//#Preview {
    @Previewable @State var model = MangaViewModel()
    
    ContentView()
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
//        .modelContainer(for: Item.self, inMemory: true)
}
