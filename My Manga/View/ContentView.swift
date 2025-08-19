//
//  ContentView.swift
//  My Manga
//
//  Created by Javier Bistue on 16/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Namespace private var namespace

    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical.fill") {
                LibraryView()
                    .navigationBarTitle("Library")
            }
            
            Tab("Store", systemImage: "bag.fill") {
                StoreView(namespace: namespace)
                    .navigationBarTitle("Store")
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .sampleData) {
    @Previewable @State var model = MangaViewModel()
    @Previewable @State var imageModel = AsyncImageViewModel()
    
    ContentView()
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}
