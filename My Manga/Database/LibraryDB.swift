//
//  LibraryDB.swift
//  My Manga
//
//  Created by Javier Bistue on 7/7/25.
//
import Foundation
import SwiftData

//@Model
//final class LibraryDB: Identifiable {
//    @Attribute(.unique) var id: Int
//    var completeCollection: Bool
//    var volumesOwned: [Int]
//    var readingVolume: Int?
//    
//    init(id: Int, completedCollection: Bool, volumesOwned: [Int], readingVolume: Int?) {
//        self.id = id
//        self.completeCollection = completedCollection
//        self.volumesOwned = volumesOwned
//        self.readingVolume = readingVolume
//    }
//}

struct LibraryItem: Identifiable, Codable {
    let id: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}

func loadLibraryItems() -> [LibraryItem] {
    guard let url = Bundle.main.url(forResource: "library", withExtension: "json"),
            let data = try? Data(contentsOf: url),
          let libraryItems = try? JSONDecoder().decode([LibraryItem].self, from: data) else {
        return []
    }
    return libraryItems
}
