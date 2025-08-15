//
//  CoverView.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

struct CoverView: View {
    let manga: Manga
    let namespace: Namespace.ID
    
    var body: some View {
        MangaImageView(url: manga.mainPicture)
//            .resizable()
//            .scaledToFit()
//            .cornerRadius(10)
//            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
            .matchedTransitionSource(id: "cover_\(manga.id)", in: namespace)
            .overlay(alignment: .bottom) {
                title
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
}
