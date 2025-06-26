//
//  Manga.swift
//  My Manga
//
//  Created by Javier Bistue on 17/6/25.
//

import Foundation

// MARK: - Manga
struct Manga: Codable {
    let id: Int
    let title, titleEnglish, titleJapanese: String?
    let startDate: Date
    let endDate: Date?
    let status: String? // Status
    let chapters, volumes: Int?
    let score: Double
    let sypnosis: String
    let background: String?
    let themes: [Theme]
    let genres: [Gender]
    let demographics: [Demographic]
    let authors: [Author]
    let url, mainPicture: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.titleEnglish = try container.decode(String.self, forKey: .titleEnglish)
        self.titleJapanese = try container.decode(String.self, forKey: .titleJapanese)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
        self.status = try container.decode(String.self, forKey: .status)
        self.chapters = try container.decode(Int.self, forKey: .chapters)
        self.volumes = try container.decode(Int.self, forKey: .volumes)
        self.score = try container.decode(Double.self, forKey: .score)
        self.sypnosis = try container.decode(String.self, forKey: .sypnosis)
        self.background = try container.decode(String.self, forKey: .background)
        self.themes = try container.decode([Theme].self, forKey: .themes)
        self.genres = try container.decode([Gender].self, forKey: .genres)
        self.demographics = try container.decode([Demographic].self, forKey: .demographics)
        self.authors = try container.decode([Author].self, forKey: .authors)
        
        self.url = if let url = try container.decodeIfPresent(String.self, forKey: .url)?.trimmingCharacters(in: CharacterSet(charactersIn: "\"")) {
            URL(string: url)
        } else {
            nil
        }
        
        self.mainPicture = if let mainPicture = try container.decodeIfPresent(String.self, forKey: .mainPicture)?.trimmingCharacters(in: CharacterSet(charactersIn: "\"")) {
            URL(string: mainPicture)
        } else {
            nil
        }
    }
}

extension Manga {
    // MARK: - Demographic
    struct Demographic: Codable {
        let id, demographic: String
    }
    
    // MARK: - Gender
    struct Gender: Codable {
        let id, genre: String
    }
    
    // MARK: - Theme
    struct Theme: Codable {
        let id, theme: String
    }
    
    // MARK: Status
//    enum Status: String, Codable {
//        case currentlyPublishing = "currently_publishing"
//        case finished = "finished"
//    }
}

// MARK: - Author
struct Author: Codable {
    let id, firstName, lastName, role: String
}

// MARK: -
struct Mangas: Codable {
    let mangas: [Manga]
    let metadata: Metadata
}

// MARK: - Metadata
struct Metadata: Codable {
    let total, per, page: Int
}
