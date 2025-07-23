//
//  AsyncImageViewModel.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

@Observable
@MainActor
final class AsyncImageViewModel {
    let downloader: ImageDownloader
    
    var image: UIImage?
    
    init(downloader: ImageDownloader = .shared) {
        self.downloader = downloader
    }
    
    func getImage(from url: URL) {
        let urlDoc = downloader.urlDoc(url: url)
        
        if FileManager.default.fileExists(atPath: urlDoc.path) {
            guard let data = try? Data(contentsOf: urlDoc) else { return }
            
            image = UIImage(data: data)
        } else {
            Task {
                do {
                    image = try await downloader.image(for: url)
                } catch {
                    print("Error retrieving image: \(error)")
                }
            }
        }
    }
}
