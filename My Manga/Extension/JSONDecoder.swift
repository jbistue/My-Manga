//
//  JSONDecoder.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import Foundation

extension JSONDecoder {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
