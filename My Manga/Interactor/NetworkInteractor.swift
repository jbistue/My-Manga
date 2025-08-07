//
//  NetworkInteractor.swift
//  My Manga
//
//  Created by Javier Bistue on 20/6/25.
//

import Foundation

protocol NetworkInteractor {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
}

extension NetworkInteractor {
    var session: URLSession { .shared }
    var decoder: JSONDecoder { .init() }
    
    func getJSON<JSON>(_ request: URLRequest, type: JSON.Type, status: Int = 200) async throws(NetworkError) -> JSON where JSON: Decodable {
        let (data, reponse) = try await session.getData(for: request)
        
        guard reponse.statusCode == status else {
            throw .status(reponse.statusCode)
        }
        
        do {
            return try decoder.decode(JSON.self, from: data)
        } catch {
            throw .json(error)
        }
    }
    
    func getStatus(_ request: URLRequest, status: Int = 200) async throws(NetworkError) {
        let (_, reponse) = try await session.getData(for: request)
        if reponse.statusCode != status {
            throw .status(reponse.statusCode)
        }
    }
}
