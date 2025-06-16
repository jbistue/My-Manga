//
//  Item.swift
//  My Manga
//
//  Created by Javier Bistue on 16/6/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
