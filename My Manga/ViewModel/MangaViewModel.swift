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
    private let loader = MangaDataLoader()
    private(set) var mangasDict: [Int: Manga] = [:]  // Diccionario para acceso rápido por id
    
    var demographics = [String]()
    var genres = [String]()
    var themes = [String]()
    var authors = [Author]()
    
//    var manga: Manga? = nil
    var mangas: [Manga] = []
    var mangaFilter = "list/mangas"
    var menuLabel = String(localized: "All")
    
    var currentPage = 1
    private let perPage = 30
    var isLoading = false
    var hasMorePages = true
    
//    var isAlertPresented = false
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
                async let authors = loader.getAuthors()

                self.demographics = try await demographics
                self.genres = try await genres
                self.themes = try await themes
                self.authors = try await authors
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
        defer { isLoading = false }
            
        do {
            let mangaNewItems = try await repository.getMangasBy(filter: mangaFilter, page: currentPage, per: perPage)

            if mangaNewItems.isEmpty {
                hasMorePages = false
            } else {
                // Actualizar el diccionario con los nuevos mangas antes de añadirlos al array
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
    
//    func getMangaDetail(id: Int) async {
//        do {
//            manga = try await repository.getMangaDetail(manga: id)
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
    
    // Método para obtener por id (usado en Biblioteca)
    func mangaBy(id: Int) -> Manga? {
        mangasDict[id]
    }
    
    func fetchMangaIfNeeded(for id: Int) async {
//        if mangasDict[id] != nil { return }
        guard mangasDict[id] == nil else { return }
        
        do {
            let manga = try await repository.getMangaDetail(manga: id)
            mangasDict[id] = manga
        } catch {
            errorMessage = error.localizedDescription
        }
//        if mangasDict[id] != nil { return }
        
//        await getMangaDetail(id: id)
//        
//        if let fetchedManga = manga {
//            if mangasDict[id] == nil {
//                mangasDict[id] = fetchedManga
//            }
//        }
    }
}
