//
//  TestContainer.swift
//  My Manga
//
//  Created by Javier Bistue on 11/7/25.
//

import Foundation
import SwiftData

final class TestContainer {
    private let decoder: JSONDecoder = .decoder
    
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var urlLibrary: URL? {
        Bundle.main.url(forResource: "library", withExtension: "json")!
    }
    
    func save() throws {
        try modelContext.save()
    }
    
    func loadLibraryItems() throws {
        guard let url = urlLibrary else {
            print("No se encontró 'library.json' en el bundle")
            return
        }
        
        let data = try Data(contentsOf: url)
        let libraryItems = try decoder.decode([LibraryItem].self, from: data)
        libraryItems.map {
            LibraryItemDB(id: $0.id, completeCollection: $0.completeCollection, volumesOwned: $0.volumesOwned, readingVolume: $0.readingVolume)
        }.forEach {
            modelContext.insert($0)
        }
    }
}

struct LibraryItem: Identifiable, Codable {
    let id: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}
