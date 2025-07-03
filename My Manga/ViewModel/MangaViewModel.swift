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
    
    var demographics = [String]()
    var genres = [String]()
    var themes = [String]()
    var authors = [Author]()
    var manga: Manga? = nil
    var mangas = Mangas(items: [], metadata: Metadata(total: 0, per: 0, page: 0))
    
    // var isAlertPresented = false
    var errorMessage: String?
    
    init(repository: NetworkRepository = Repository()) {
        self.repository = repository
    }
    
    func loadInitialData() {
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
    func getMangas() async {
        do {
            mangas = try await repository.getMangas(page: 1, per: 30)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getMangaDetail(id: Int) async {
        do {
            manga = try await repository.getMangaDetail(manga: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
//    func getThemes() async {
//        do {
//            themes = try await repository.getThemes().sorted(by: <)
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
//    
//    func getGenres() async {
//        do {
//            genres = try await repository.getGenres().sorted(by: <)
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
//        
//    func getDemographics() async {
//        do {
//            demographics = try await repository.getDemographics().sorted(by: <)
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
}
