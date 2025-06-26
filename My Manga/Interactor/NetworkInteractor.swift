//
//  NetworkInteractor.swift
//  My Manga
//
//  Created by Javier Bistue on 20/6/25.
//

import Foundation
//import OSLog

protocol NetworkInteractor {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    
//    var logger: Logger { get }
}

extension NetworkInteractor {
    var session: URLSession { .shared }
    var decoder: JSONDecoder { .init() }
    
//    var logger: Logger {
//        Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "network")
//    }
    
    func getJSON<JSON>(_ request: URLRequest, type: JSON.Type, status: Int = 200) async throws(NetworkError) -> JSON where JSON: Decodable {
//        logger.debug("Request: \(request.url?.absoluteString ?? "")")
        
        let (data, reponse) = try await session.getData(for: request)
        
//        logger.debug("Response: Status=\(reponse.statusCode)")
//        logger.debug("Response: Data=\(String(data: data, encoding: .utf8) ?? "")")
        
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
