//
//  ContentView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(MangaViewModel.self) var model
    
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]

    var body: some View {
        TabView {
            // Tab("Home", systemImage: "house") {
            Tab("Mangas", systemImage: "house") {
                MangaListView()
                    .navigationBarTitle("Home")
            }
            
            // Tab("Library", systemImage: "books.vertical.fill") {
            Tab("Demographics", systemImage: "books.vertical.fill") {
                DemographicsView()
                    .navigationBarTitle("Library")
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
            
            // Tab("Settings", systemImage: "gear") {
            Tab("Authors", systemImage: "gear") {
                AuthorsView()
                    .navigationBarTitle("Settings")
            }
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    ContentView()
        .task {
            model.loadInitialData()
        }
        .environment(model)
//        .modelContainer(for: Item.self, inMemory: true)
}
