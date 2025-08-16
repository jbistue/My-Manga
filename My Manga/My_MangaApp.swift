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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([LibraryItemDB.self,])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        model.loadMangaClassifications()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
        .modelContainer(sharedModelContainer)
    }
}
