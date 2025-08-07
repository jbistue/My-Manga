//
//  LibraryItemDB.swift
//  My Manga
//
//  Created by Javier Bistue on 7/7/25.
//

import Foundation
import SwiftData

@Model
final class LibraryItemDB {
    @Attribute(.unique) var id: Int
    var completeCollection: Bool
    var volumesOwned: [Int]
    var readingVolume: Int?
    
    init(id: Int, completeCollection: Bool, volumesOwned: [Int], readingVolume: Int?) {
        self.id = id
        self.completeCollection = completeCollection
        self.volumesOwned = volumesOwned
        self.readingVolume = readingVolume
    }
}
