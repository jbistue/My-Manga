//
//  My_MangaApp.swift
//  My Manga
//
//  Created by Javier Bistue on 16/6/25.
//

import SwiftUI
import SwiftData

@main
struct My_MangaApp: App {
    @State private var model = MangaViewModel(repository: Repository())

//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    init() {
        model.loadInitialData()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
//        .modelContainer(sharedModelContainer)
    }
    
//    func loadData(_ container: ModelContainer) async {
//        // let container = MangaContainer(modelContainer: container)
//        let container = MangaContainer()
//        mangaModel.container = container
//        
//        do {
//            // mangaModel.state = .loading
//            try await container.loadInitialData()
//            // mangaModel.state = .loaded
//        } catch {
//            print("Error loading initial data: \(error)")
//            // mangaModel.state = .error(error)
//        }
//    }
}
