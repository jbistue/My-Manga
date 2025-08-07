//
//  SampleData.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import SwiftUI
import SwiftData

extension Manga {
    static var test: Manga {
        guard
            let url = Bundle.main.url(forResource: "detail", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let manga = try? JSONDecoder.decoder.decode(Manga.self, from: data)
        else {
            fatalError("No se pudo cargar 'detail.json'")
        }
        return manga
    }
    
    static var testInLibrary: Manga {
        guard
            let url = Bundle.main.url(forResource: "detail_in_library", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let manga = try? JSONDecoder.decoder.decode(Manga.self, from: data)
        else {
            fatalError("No se pudo cargar 'detail.json'")
        }
        return manga
    }
}

struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: LibraryItemDB.self, configurations: configuration)
        let context = container.mainContext
        
        let testContainer = TestContainer(modelContext: context)
        try testContainer.loadLibraryItems()
        try testContainer.save()
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var sampleData: Self = .modifier(SampleData())
}
