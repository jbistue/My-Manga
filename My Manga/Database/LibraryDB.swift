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

//final class Library: Identifiable, Codable {
//    var items: [LibraryItem]
//    
//    init(items: [LibraryItem] = []) {
//        self.items = items
//    }
//}

struct LibraryItem: Identifiable, Codable {
    let id: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}

//@Observable
//final class LibraryItem: Identifiable, Codable {
//    var id: Int
//    var completeCollection: Bool
//    var volumesOwned: [Int]
//    var readingVolume: Int?
//    
//    init(id: Int, completeCollection: Bool = false, volumesOwned: [Int] = [], readingVolume: Int? = nil) {
//        self.id = id
//        self.completeCollection = completeCollection
//        self.volumesOwned = volumesOwned
//        self.readingVolume = readingVolume
//    }
    
//    static func loadLibraryItems() -> [LibraryItem] {
//        guard let url = Bundle.main.url(forResource: "library", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let libraryItems = try? JSONDecoder().decode([LibraryItem].self, from: data) else {
//            return []
//        }
//        return libraryItems
//    }
//}

func loadLibraryItems() -> [LibraryItem] {
    guard let url = Bundle.main.url(forResource: "library", withExtension: "json"),
            let data = try? Data(contentsOf: url),
          let libraryItems = try? JSONDecoder().decode([LibraryItem].self, from: data) else {
        return []
    }
    return libraryItems
}
