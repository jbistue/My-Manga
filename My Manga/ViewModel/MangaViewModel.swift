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
    
//    @ObservationIgnored
//    private var mangasPage = Mangas(items: [], metadata: Metadata(total: 0, per: 0, page: 0))
    
    var demographics = [String]()
    var genres = [String]()
    var themes = [String]()
    var authors = [Author]()
    var manga: Manga? = nil
    var mangas: [Manga] = []
    var mangaFilter = "mangas"
    
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

//        if reset {
//            currentPage = 1
//            mangas = []
//            hasMorePages = true
//        }
            
        do {
            let mangaNewItems = try await repository.getFilteredMangas(filter: mangaFilter, page: currentPage, per: perPage)

            if mangaNewItems.items.isEmpty {
                hasMorePages = false
            } else {
                mangas.append(contentsOf: mangaNewItems.items)
                currentPage += 1
            }
        } catch {
                errorMessage = error.localizedDescription
        }
            
        isLoading = false
        }
    
    func getMangaDetail(id: Int) async {
        do {
            manga = try await repository.getMangaDetail(manga: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

//    func fetchMangas(reset: Bool = false) async {
//    func fetchMangas() async {
//        guard !isLoading, hasMorePages else { return }
//
//        isLoading = true
//
////        if reset {
////            currentPage = 1
////            mangas = []
////            hasMorePages = true
////        }
//            
//        do {
//            let mangaNewItems = try await repository.getMangas(page: currentPage, per: perPage)
//
//            if mangaNewItems.items.isEmpty {
//                hasMorePages = false
//            } else {
//                mangas.append(contentsOf: mangaNewItems.items)
//                currentPage += 1
//            }
//        } catch {
//                errorMessage = error.localizedDescription
//        }
//            
//        isLoading = false
//        }

//    func getMangas(page: Int, per: Int) async {
//        do {
//            mangas = try await repository.getMangas(page: page, per: per).items
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }


