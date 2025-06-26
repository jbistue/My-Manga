//
//  URLSession.swift
//  My Manga
//
//  Created by Javier Bistue on 17/6/25.
//

import Foundation

extension URLSession {
    func getData(from url: URL) async throws(NetworkError) -> (
        data: Data,
        response: HTTPURLResponse
    ) {
        do {
            let (data, response) = try await data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            // Si el token ha caducado, llamo a refrescarlo y me vuelvo a llamar recursivamente
            let string = String(data: data, encoding: .utf8)
            print(string ?? "No se pudo decodificar el JSON")
            return (data, httpResponse)
        } catch let error as NetworkError { // Si no añado esto, quedaría `NetworkError.general(NetworkError.nonHTTP)`
            throw error
        } catch {
            throw .general(error)
        }
    }
    
    func getData(for request: URLRequest) async throws(NetworkError) -> (
        data: Data,
        response: HTTPURLResponse
    ) {
        do {
            let (data, response) = try await data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            return (data, httpResponse)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .general(error)
        }
    }
}
