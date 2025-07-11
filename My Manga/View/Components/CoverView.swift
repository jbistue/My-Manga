//
//  CoverView.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

struct CoverView: View {
    private let model = AsyncImageViewModel()
    let manga: Manga
    let namespace: Namespace.ID
    
    var body: some View {
        if let cover = model.image {
            Image(uiImage: cover)
                .resizable()
                .scaledToFit()
                .matchedTransitionSource(id: "cover_\(manga.id)", in: namespace)
                .overlay(alignment: .bottom) {
                    title
                }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .padding()
                .matchedTransitionSource(id: "cover_\(manga.id)", in: namespace)
                .overlay(alignment: .bottom) {
                    title
                }
                .task {
                    if let url = manga.mainPicture {
                        model.getImage(from: url)
                    }
                }
        }
    }
    
    private var title: some View {
        Text(manga.title ?? "N/A")
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .lineLimit(1, reservesSpace: true)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
            .padding(5)
            .background {
                Color.black.opacity(0.7)
            }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    CoverView(manga: .test, namespace: namespace)
//    CoverView(manga: .test)
}
