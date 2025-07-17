//
//  Manga.swift
//  My Manga
//
//  Created by Javier Bistue on 17/6/25.
//

import Foundation

//struct MangaResponse: Codable {
//    let results: [Manga]
//}

// MARK: - Manga
struct Manga: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let title, titleEnglish, titleJapanese: String?
    let startDate, endDate: Date?
    let status: Status
    let chapters, volumes: Int?
    let score: Double?
    let sypnosis: String?
    let background: String?
    let themes: [Theme]
    let genres: [Gender]
    let demographics: [Demographic]
    let authors: [Author]
    let url, mainPicture: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.titleEnglish = try container.decodeIfPresent(String.self, forKey: .titleEnglish)
        self.titleJapanese = try container.decodeIfPresent(String.self, forKey: .titleJapanese)
        self.startDate = try container.decodeIfPresent(Date.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        self.status = try container.decode(Status.self, forKey: .status)
        self.chapters = try container.decodeIfPresent(Int.self, forKey: .chapters)
        self.volumes = try container.decodeIfPresent(Int.self, forKey: .volumes)
        self.score = try container.decodeIfPresent(Double.self, forKey: .score)
        self.sypnosis = try container.decodeIfPresent(String.self, forKey: .sypnosis)
        self.background = try container.decodeIfPresent(String.self, forKey: .background)
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
    struct Demographic: Codable, Hashable {
        let id, demographic: String
    }
    
    // MARK: - Gender
    struct Gender: Codable, Hashable {
        let id, genre: String
    }
    
    // MARK: - Theme
    struct Theme: Codable, Hashable {
        let id, theme: String
    }
    
    // MARK: Status
    enum Status: String, Codable {
        case currentlyPublishing = "currently_publishing"
        case finished
        case onHiatus = "on_hiatus"
        case cancelled
        case unknown

        init(rawValue: String) {
            switch rawValue {
            case "currently_publishing":
                self = .currentlyPublishing
            case "finished":
                self = .finished
            case "on_hiatus":
                self = .onHiatus
            case "cancelled":
                self = .cancelled
            default:
                self = .unknown
            }
        }

        var description: String {
            switch self {
            case .currentlyPublishing: String(localized: "Currently Publishing")
            case .finished: String(localized: "Finished")
            case .onHiatus: String(localized: "On Hiatus")
            case .cancelled: String(localized: "Cancelled")
            case .unknown: String(localized: "Unknown")
            }
        }
    }
}

// MARK: - Author
struct Author: Codable, Hashable, Identifiable {
    let id, firstName, lastName, role: String
}

// MARK: -
struct Mangas: Codable {
    let items: [Manga]
    let metadata: Metadata
}

// MARK: - Metadata
struct Metadata: Codable {
    let total, per, page: Int
}
