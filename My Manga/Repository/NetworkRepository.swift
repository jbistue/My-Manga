//
//  NetworkRepository.swift
//  My Manga
//
//  Created by Javier Bistue on 20/6/25.
//

import Foundation

protocol NetworkRepository: NetworkInteractor, Sendable {
    var token: String? { get }
    
    func getDemographics() async throws(NetworkError) -> [String]
    func getGenres() async throws(NetworkError) -> [String]
    func getThemes() async throws(NetworkError) -> [String]
    func getAuthors() async throws(NetworkError) -> [Author]
    func getMangasBy(filter: String, page: Int, per: Int) async throws(NetworkError) -> [Manga]
    func getMangaDetail(manga: Int) async throws(NetworkError) -> Manga
}

extension NetworkRepository {
    var token: String? { nil }
    
    func getDemographics() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .demographics, token: token), type: [String].self)
    }
    
    func getGenres() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .genres, token: token), type: [String].self)
    }
    
    func getThemes() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .themes, token: token), type: [String].self)
    }

    func getAuthors() async throws(NetworkError) -> [Author] {
        try await getJSON(.get(url: .authors, token: token), type: [Author].self)
    }
   
    func getMangasBy(filter: String, page: Int, per: Int) async throws(NetworkError) -> [Manga] {
        try await getJSON(.get(url: .filterOrSearchMangas(by: filter, page: page, per: per), token: token), type: Mangas.self).items
    }
        
    func getMangaDetail(manga: Int) async throws(NetworkError) -> Manga {
        try await getJSON(.get(url: .manga(id: manga), token: token), type: Manga.self)
    }
}

struct Repository: NetworkRepository {
//    let token: String? = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjN2JmMTUwNGMwNWVmNjY4MTlkZGE1ZjkyZTAwOTg1MyIsIm5iZiI6MTU1NDQwODEwMy44NzM5OTk4LCJzdWIiOiI1Y2E2NjJhN2MzYTM2ODYxNDYxNzBkMTMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.prtR6kaWEp9nhU67CbUfFMNMhcoqxdDbGJyrevDJmGw"
    
    let decoder: JSONDecoder = .decoder
}
