//
//  URL.swift
//  My Manga
//
//  Created by Javier Bistue on 17/6/25.
//

import Foundation

let apiURL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/")!

extension URL {
    static let themes = apiURL.appending(path: "list/themes")
    
    static let genres = apiURL.appending(path: "list/genres")
    
    static let demographics = apiURL.appending(path: "list/demographics")

// MARK: en esta versión no se implementa authors
//    static let authors = apiURL.appending(path: "list/authors")
    
    static func manga(id: Int) -> URL {
        apiURL.appending(path: "search/manga/\(id)")
    }
    
    static func filterOrSearchMangas(by: String, page: Int, per: Int) -> URL {
        apiURL.appending(path: by).appending(queryItems: [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per", value: String(per))])
    }
}
