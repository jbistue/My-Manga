//
//  MangaImageView.swift
//  My Manga
//
//  Created by Javier Bistue on 28/7/25.
//

import SwiftUI

struct MangaImageView: View {
    @State var model = AsyncImageViewModel()
//    @StateObject private var model = AsyncImageViewModel()

//    private let model = AsyncImageViewModel()
//    let manga: Manga
    let url: URL?
    
    var body: some View {
        Group {                             // OJO CON EL GROUP POR SI DA PROBLEMAS...
            if let image = model.image {
                Image(uiImage: image)
                    .resizable()
//                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
            } else {
                Image(systemName: "photo")
                    .resizable()
//                    .scaledToFit()
                    .padding(100)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(.circle)
//                    .onAppear {
//                        guard let url else { return }
////                        if let url = manga.mainPicture {
//                            model.getImage(from: url)
////                        }
//                    }
            }
        }
        .onAppear {
            guard let url else { return }
            model.getImage(from: url)
        }
    }
}

#Preview {
//    @Previewable @State var imageModel = AsyncImageViewModel()
//    MangaImageView(url: URL(string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"), model: AsyncImageViewModel())
//    MangaImageView(manga: .test)
    MangaImageView(url: URL(string: "https://cdn.myanimelist.net/images/manga/1/267793l.jpg"))
//        .environment(imageModel)
}
