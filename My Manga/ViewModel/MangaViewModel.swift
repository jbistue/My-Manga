//
//  MangaViewModel.swift
//  My Manga
//
//  Created by Javier Bistue on 23/6/25.
//

import SwiftUI

@Observable
final class MangaViewModel {
    private let repository: NetworkRepository // = NetworkRepository()
    
//    var artObjectIDs: [Int] = []
//    var mangas: [Manga] = []
    var manga: Manga? = nil
    var themes: [String] = []
    var genres: [String] = []
    var demographics: [String] = []
    var mangas: Mangas = Mangas(mangas: [], metadata: Metadata(total: 0, per: 0, page: 0))
//    var artObject: ArtObject?
    
    // var isAlertPresented = false
    var errorMessage: String?
    
    init(repository: NetworkRepository = Repository()) {
        self.repository = repository
    }
}

@MainActor
extension MangaViewModel {
//    func getMangas() async {
//        print("aquí estoy ...")
//        do {
//            mangas = try await repository.getMangas(page: 1, per: 10)
//            // print("Mangas obtenidos: \(mangas)")
//            // print("Mangas obtenidos ...")
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        print("Mangas obtenidos ...")
//    }
    
    func getMangaDetail(id: Int) async {
        do {
            manga = try await repository.getDetail(manga: id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getThemes() async {
        do {
            themes = try await repository.getThemes().sorted(by: <)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getGenres() async {
        do {
            genres = try await repository.getGenres().sorted(by: <)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
        
    func getDemographics() async {
        do {
            demographics = try await repository.getDemographics().sorted(by: <)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
    
