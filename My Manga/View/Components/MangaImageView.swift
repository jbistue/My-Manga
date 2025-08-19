//
//  MangaImageView.swift
//  My Manga
//
//  Created by Javier Bistue on 28/7/25.
//

import SwiftUI

struct MangaImageView: View {
    @State private var imageModel = AsyncImageViewModel()

    let url: URL?
    
//    private var placeholder: UIImage {
//        let original = UIImage(named: "no_manga_image")!
//        let targetWidth: CGFloat = 512
//        let scale = original.size.width / targetWidth
//        let height = max(1, original.size.height / scale)
//        
//        return UIGraphicsImageRenderer(size: .init(width: targetWidth, height: height))
//            .image { _ in
//                original.draw(in: CGRect(origin: .zero, size: .init(width: targetWidth, height: height)))
//            }
//    }
    
    var body: some View {
        Group {
            if let image = imageModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
//                Image(uiImage: placeholder)
                Image("no_manga_image")
                    .resizable()
                    .scaledToFit()
                    .task {
                        guard let url else { return }
                        
                        imageModel.getImage(from: url)
                    }
            }
        }
    }
            
}

#Preview("Con imagen") {
    MangaImageView(url: URL(string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"))
}

#Preview("Sin imagen") {
    MangaImageView(url: nil)
}
