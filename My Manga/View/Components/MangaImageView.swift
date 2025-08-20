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
    
    var body: some View {
        if let image = imageModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
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

#Preview("Con imagen") {
    MangaImageView(url: URL(string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"))
}

#Preview("Sin imagen") {
    MangaImageView(url: nil)
}
