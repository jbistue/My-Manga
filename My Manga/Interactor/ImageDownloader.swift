//
//  ImageDownloader.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

actor ImageDownloader {
    static let shared = ImageDownloader()
    
    enum ImageStatus {
        case downloading(task: Task<UIImage, any Error>)
        case downloaded(image: UIImage)
    }
    
    private var cache: [URL: ImageStatus] = [:]
    
    func image(for url: URL) async throws -> UIImage {
        if let imageStatus = cache[url] {
            switch imageStatus {
            case .downloading(let task): return try await task.value
            case .downloaded(let image): return image
            }
        }
        
        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.cannotDecodeContentData)
            }
        }
        
        cache[url] = .downloading(task: task)
        
        do {
            let image = try await task.value
            cache[url] = .downloaded(image: image)
            return try await saveImage(url: url)
        } catch {
            cache.removeValue(forKey: url)
            throw error
        }
    }
    
    private func saveImage(url: URL) async throws -> UIImage {
        guard let imageCached = cache[url] else { throw URLError(.resourceUnavailable) }
        
        if case .downloaded(let image) = imageCached,
           let resized = await resizeImage(image),
           let heicData = resized.heicData() {
            let urlDoc = urlDoc(url: url)
            try heicData.write(to: urlDoc)
            cache.removeValue(forKey: url)
            return resized
        } else {
            throw URLError(.cannotDecodeContentData)
        }
    }
    
    private func resizeImage(_ image: UIImage) async -> UIImage? {
        guard image.size.width > 0, image.size.height > 0 else {
            return nil
        }
        
        let targetWidth: CGFloat = 512
        let scale = image.size.width / targetWidth
        let height = max(1, image.size.height / scale)
        
        return await image.byPreparingThumbnail(ofSize: .init(width: targetWidth, height: height))
    }
    
    nonisolated func urlDoc(url: URL) -> URL {
        URL.cachesDirectory
            .appendingPathComponent(url.deletingPathExtension().lastPathComponent)
            .appendingPathExtension("heic")
    }
}
