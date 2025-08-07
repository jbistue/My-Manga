//
//  ClassificationsLoader.swift
//  My Manga
//
//  Created by Javier Bistue on 2/7/25.
//

import Foundation

actor ClassificationsLoader {
    let repository: NetworkRepository = Repository()
    
    func getDemographics() async throws -> [String] {
        let demographics = try await repository.getDemographics()
        return demographics.sorted(by: <)
    }
    
    func getGenres() async throws -> [String] {
        let genres = try await repository.getGenres()
        return genres.sorted(by: <)
    }
    
    func getThemes() async throws -> [String] {
        let themes = try await repository.getThemes()
        return themes.sorted(by: <)
    }
    
    func getAuthors() async throws -> [Author] {
        let authors = try await repository.getAuthors()
        return authors.sorted(by: { $0.lastName < $1.lastName })
    }
}
