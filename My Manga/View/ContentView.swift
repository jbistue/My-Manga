//
//  ContentView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @State private var model = MangaViewModel(repository: Repository())
    
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                MangaDetailView()
                    .navigationBarTitle("Home")
            }
            
            Tab("Themes", systemImage: "list.bullet") {
                ThemesView()
                    .navigationBarTitle("Themes")
            }
            
            Tab("Genres", systemImage: "list.bullet") {
                GenresView()
                    .navigationBarTitle("Genres")
            }
            
            Tab("Demographics", systemImage: "list.bullet") {
                DemographicsView()
                    .navigationBarTitle("Demographics")
            }
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
