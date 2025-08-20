//
//  MangaViewModel.swift
//  My Manga
//
//  Created by Javier Bistue on 23/6/25.
//

import SwiftUI

@Observable
@MainActor
final class MangaViewModel {
    private let repository: NetworkRepository
    private let loader = ClassificationsLoader()
    private(set) var mangasDict: [Int: Manga] = [:]
    
    var demographics = [String]()
    var genres = [String]()
    var themes = [String]()
// MARK: en esta versión no se implementa authors
//    var authors = [Author]()
    
    var mangas: [Manga] = []
    var mangaFilter = "list/mangas"
    var menuLabel = String(localized: "All")
    
    var currentPage = 1
    private let perPage = 20
    var isLoading = false
    var hasMorePages = true
    private var loadingIDs: Set<Int> = []

    var errorMessage: String?
    
    init(repository: NetworkRepository = Repository()) {
        self.repository = repository
    }
    
    func loadMangaClassifications() {
        Task {
            do {
                async let demographics = loader.getDemographics()
                async let genres = loader.getGenres()
                async let themes = loader.getThemes()
//                async let authors = loader.getAuthors()

                self.demographics = try await demographics
                self.genres = try await genres
                self.themes = try await themes
//                self.authors = try await authors
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

@MainActor
extension MangaViewModel {
    func fetchFilteredMangas() async {
        guard !isLoading, hasMorePages else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
            
        do {
            let mangaNewItems = try await repository.getMangasBy(filter: mangaFilter, page: currentPage, per: perPage)

            if mangaNewItems.isEmpty {
                hasMorePages = false
            } else {
                for manga in mangaNewItems {
                    mangasDict[manga.id] = manga
                }
                mangas.append(contentsOf: mangaNewItems)
                currentPage += 1
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func mangaBy(id: Int) -> Manga? {
        mangasDict[id]
    }
    
    func fetchMangaIfNeeded(for id: Int) async {
        guard !loadingIDs.contains(id), mangasDict[id] == nil else { return }
        
        loadingIDs.insert(id)
        defer { loadingIDs.remove(id) }
        
        do {
            let manga = try await repository.getMangaDetail(manga: id)
            mangasDict[id] = manga
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
