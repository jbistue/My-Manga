//
//  NetworkRepository.swift
//  My Manga
//
//  Created by Javier Bistue on 20/6/25.
//

import Foundation

protocol NetworkRepository: NetworkInteractor, Sendable {
    var token: String? { get }
    
    func getThemes() async throws(NetworkError) -> [String]
    func getGenres() async throws(NetworkError) -> [String]
    func getDemographics() async throws(NetworkError) -> [String]
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> Mangas
//    func getNowPlaying() async throws(NetworkError) -> [Manga]
//    func getUpcoming() async throws(NetworkError) -> [Manga]
    func getDetail(manga: Int) async throws(NetworkError) -> Manga
}

extension NetworkRepository {
    var token: String? { nil }
    
    func getThemes() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .themes, token: token), type: [String].self)
    }
    
    func getGenres() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .genres, token: token), type: [String].self)
    }
    
    func getDemographics() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .demographics, token: token), type: [String].self)
    }
    
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> Mangas {
//        try await getJSON(.get(url: .mangas(page: page, per: per), token: token), type: Manga.self).genres
        try await getJSON(.get(url: .mangas(page: page, per: per), token: token), type: Mangas.self)
    }
    
//    func getNowPlaying() async throws(NetworkError) -> [Manga] {
//        try await getJSON(.get(url: .nowPlaying, token: token), type: Manga.self).results
//    }
//    
//    func getUpcoming() async throws(NetworkError) -> [Manga] {
//        try await getJSON(.get(url: .upcoming, token: token), type: Manga.self).results
//    }
    
    func getDetail(manga: Int) async throws(NetworkError) -> Manga {
        try await getJSON(.get(url: .manga(id: manga), token: token), type: Manga.self)
    }
}

struct Repository: NetworkRepository {
//    let token: String? = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjN2JmMTUwNGMwNWVmNjY4MTlkZGE1ZjkyZTAwOTg1MyIsIm5iZiI6MTU1NDQwODEwMy44NzM5OTk4LCJzdWIiOiI1Y2E2NjJhN2MzYTM2ODYxNDYxNzBkMTMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.prtR6kaWEp9nhU67CbUfFMNMhcoqxdDbGJyrevDJmGw"
    
    let decoder: JSONDecoder = .decoder
}
