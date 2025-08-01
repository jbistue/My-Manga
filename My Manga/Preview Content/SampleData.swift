//
//  SampleData.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import SwiftUI
import SwiftData

extension Manga {
//    static let test: Manga = {
//        let url = Bundle.main.url(forResource: "detail", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        return try! JSONDecoder.decoder.decode(Manga.self, from: data)
//    }()
    
    static var test: Manga {
        guard
            let url = Bundle.main.url(forResource: "detail", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let manga = try? JSONDecoder.decoder.decode(Manga.self, from: data)
        else {
            fatalError("No se pudo cargar 'detail.json'")
        }
        return manga
    }
}

struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: LibraryItemDB.self, configurations: configuration)
        let context = container.mainContext
        
        let testContainer = TestContainer(modelContext: context)
        try testContainer.loadLibraryItems()
        try testContainer.save()
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var sampleData: Self = .modifier(SampleData())
}

// TODO: Acabar tema carga datos mockeados de los mangas 1 a 30 o a 90
//@Observable
//@MainActor
//final class SampleMangaViewModel {
//    var mangas: [Manga] = []
//    var hasMorePages = true
//    
//    func fetchMangas() {
//        let url = Bundle.main.url(forResource: "manga_p1_p10", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        let mangaP1P30 = try! JSONDecoder().decode(Mangas.self, from: data)
//        mangas.append(contentsOf: mangaP1P30.items)
//        hasMorePages = false
//    }
//}

//struct PreviewRepository: NetworkRepository {
//    var mangas: [Manga] = []
//    var currentPage = 1
//    private let perPage = 30
//    var isLoading = false
//    var hasMorePages = true
//    
//    mutating func fetchMangas() {
//        guard !isLoading, hasMorePages else { return }
//
//        isLoading = true
        
//        guard let url = Bundle.main.url(forResource: "manga_p1_p30", withExtension: "json"),
//                let data = try? Data(contentsOf: url),
//                let mangaP1P30 = try? JSONDecoder().decode(Mangas.self, from: data) else {
//            return []
//        }
        
//        let url = Bundle.main.url(forResource: "manga_p1_p30", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        let mangaP1P30 = try! JSONDecoder().decode(Mangas.self, from: data)
//        mangas.append(contentsOf: mangaP1P30.items)
//        return mangaP1P30.items
//        hasMorePages = false
//    }
    
//    func loadLibraryItems() -> [LibraryItem] {
//        guard let url = Bundle.main.url(forResource: "library", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let libraryItems = try? JSONDecoder().decode([LibraryItem].self, from: data) else {
//            return []
//        }
//        return libraryItems
//    }
    
//    func getDetailsMangaLibraryDict() -> [Int: Manga] {
//        let libraryItems = loadLibraryItems()
//        let mangasP1P30 = getMangaP1P30()
//        // print(mangasP1P30)
//        var details: [Int: Manga] = [:]
//        for item in libraryItems {
////            await model.getMangaDetail(id: manga.id)
////            details[item.id] = model.manga
//            details[item.id] = mangasP1P30.first(where: { $0.id == item.id })
//        }
//        return details
//    }
//    
//    func getMangaP1P30() -> [Manga] {
//        guard let url = Bundle.main.url(forResource: "manga_p1_p30", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let mangaP1P30 = try? JSONDecoder().decode(Mangas.self, from: data) else {
//            return []
//        }
//        return mangaP1P30.items
//    }
    
//    func getMangaDetail(movie: Int) async throws(NetworkError) -> Manga {
//        let url = Bundle.main.url(forResource: "detail", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        return try! JSONDecoder.decoder.decode(Manga.self, from: data)
//    }
//}
