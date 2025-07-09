//
//  SampleData.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import Foundation

//struct PreviewRepository: NetworkRepository {
//    func getMangaDetail(movie: Int) async throws(NetworkError) -> Manga {
//        let url = Bundle.main.url(forResource: "detail", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        return try! JSONDecoder.decoder.decode(Manga.self, from: data)
//    }
//}

extension Manga {
    static let test: Manga = {
        let url = Bundle.main.url(forResource: "detail", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder.decoder.decode(Manga.self, from: data)
    }()
}

//extension LibraryItem {
//    @MainActor static let test: [LibraryItem] = {
//        let url = Bundle.main.url(forResource: "library", withExtension: "json")!
//        let data = try! Data(contentsOf: url)
//        return try! JSONDecoder.decoder.decode([LibraryItem].self, from: data)
//    }()
//}

//extension Manga {
//    init(
//        id: Int,
//        title: String? = nil,
//        titleEnglish: String? = nil,
//        titleJapanese: String? = nil,
//        startDate: Date,
//        endDate: Date? = nil,
//        status: Status,
//        chapters: Int? = nil,
//        volumes: Int? = nil,
//        score: Double,
//        sypnosis: String,
//        background: String? = nil,
//        themes: [Theme] = [],
//        genres: [Gender] = [],
//        demographics: [Demographic] = [],
//        authors: [Author] = [],
//        url: URL? = nil,
//        mainPicture: URL? = nil
//    ) {
//        self.id = id
//        self.title = title
//        self.titleEnglish = titleEnglish
//        self.titleJapanese = titleJapanese
//        self.startDate = startDate
//        self.endDate = endDate
//        self.status = status
//        self.chapters = chapters
//        self.volumes = volumes
//        self.score = score
//        self.sypnosis = sypnosis
//        self.background = background
//        self.themes = themes
//        self.genres = genres
//        self.demographics = demographics
//        self.authors = authors
//        self.url = url
//        self.mainPicture = mainPicture
//    }
//}
//
//extension Manga {
//    static let preview: Manga = {
//        let startDateString = "1984-11-20T00:00:00Z"
//        let endDateString = "1995-05-23T00:00:00Z"
//        let dateFormatter = ISO8601DateFormatter()
//        let startDate = dateFormatter.date(from: startDateString)!
//        let endDate = dateFormatter.date(from: endDateString)
//        
//        return Manga(
//            id: 42,
//            title: "Dragon Ball",
//            titleEnglish: "Dragon Ball",
//            titleJapanese: "ドラゴンボール",
//            startDate: startDate,
//            endDate: endDate,
//            status: .finished,
//            chapters: 520,
//            volumes: 42,
//            score: 8.41,
//            sypnosis: "Bulma, a headstrong 16-year-old girl, is on a quest to find the mythical Dragon Balls—seven scattered magic orbs that grant the finder a single wish. She has but one desire in mind: a perfect boyfriend. On her journey, Bulma stumbles upon Gokuu Son, a powerful orphan who has only ever known one human besides her. Gokuu possesses one of the Dragon Balls, it being a memento from his late grandfather. In exchange for it, Bulma invites Gokuu to be a companion in her travels.\n\nBy Bulma's side, Gokuu discovers a world completely alien to him. Powerful enemies embark on their own pursuits of the Dragon Balls, pushing Gokuu beyond his limits in order to protect Bulma and their growing circle of allies. However, Gokuu has secrets unbeknownst to even himself; the incredible strength within him stems from a mysterious source, one that threatens the many people he grows to hold dear.\n\nAs his prowess in martial arts flourishes, Gokuu attracts stronger opponents whose villainous plans could collapse beneath his might. He undertakes the endless venture of combat training to defend his loved ones and the fate of the planet itself.\n\n[Written by MAL Rewrite]",
//            background: "Dragon Ball has become one of the most successful manga series of all time, with over 230 million copies sold worldwide with 157 million in Japan alone, making it the third all-time best selling manga as of 2015, and the #1 manga series not currently publishing. The series is often credited for the \"Golden Age of Jump\" where the magazine's circulation was at its highest. VIZ Media serialized the manga in English from March 1998 to March 2005 in monthly comic book anthology format; and was later collected into traditional tankobon format volumes from March 12, 2003 to June 6, 2006. To closer follow the English anime localization, the series is split; in which volumes 17-42 are titled Dragon Ball Z and renumbered as volumes 1-26. Other releases by VIZ include the large format VIZ Big Edition, kanzenban cover based 3-in-1 Edition, and a Full Color Edition of chapters 195-245. Other English publishers include Madman Entertainment in Australia/New Zealand, and the now defunct Gollancz Manga (distribution rights transferred to VIZ) in the United Kingdom. The series is also published in Spanish by Planet DeAgostini Cómics and in French by Glénat Editions.",
//            themes: [Theme(id: "ADC7CBC8-36B9-4E52-924A-4272B7B2CB2C", theme: "Martial Arts"),
//                     Theme(id: "472FB2AE-13C0-4EEE-9A45-A7B75AC5DC29", theme: "Super Power")],
//            genres: [Gender(id: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD", genre: "Action"),
//                     Gender(id: "BE70E289-D414-46A9-8F15-928EAFBC5A32", genre: "Adventure"),
//                     Gender(id: "F974BCB6-B002-44A6-A224-90D1E50595A2", genre: "Comedy"),
//                     Gender(id: "2DEDC015-82DA-4EF4-B983-F0F58C8F689E", genre: "Sci-Fi")],
//            demographics: [Demographic(id: "5E05BBF1-A72E-4231-9487-71CFE508F9F9", demographic: "Shounen")],
//            authors: [Author(id: "998C1B16-E3DB-47D1-8157-8389B5345D03", firstName: "Akira", lastName: "Toriyama", role: "Story & Art")],
//            url: URL(string: "https://myanimelist.net/manga/42/Dragon_Ball")!,
//            mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg")!
//        )
//    }()
//}
