//
//  MangaDetailView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: manga.mainPicture) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 400)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
                .padding()

                Text("**English title:** \(manga.titleEnglish ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Japanese title:** \(manga.titleJapanese ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Start:** \(manga.startDate.formatted(date: .abbreviated, time: .omitted))")
                    .padding(.bottom, 2)
                Text("**End:** \(manga.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Status:** \(manga.status.description)")
                    .padding(.bottom, 2)
                Text("**Chapters:** \(String(manga.chapters ?? 0))")
                    .padding(.bottom, 2)
                Text("**Volumes:** \(String(manga.volumes ?? 0))")
                    .padding(.bottom, 2)
                Text("**Score:** \(String(manga.score))")
                    .padding(.bottom, 2)
                Text("**Background:** \(manga.background ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Synopsis:** \(manga.sypnosis)")
                    .padding(.bottom, 2)
                Text("**Themes:** \(manga.themes.map { $0.theme }.joined(separator: ", "))")
                    .padding(.bottom, 2)
                Text("**Genres:** \(manga.genres.map { $0.genre }.joined(separator: ", "))")
                    .padding(.bottom, 2)
                Text("**Demographics:** \(manga.demographics.map { $0.demographic }.joined(separator: ", "))")
                    .padding(.bottom, 2)
                Text("**Authors:** \(manga.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.joined(separator: ", "))")
                    .padding(.bottom, 2)
                Link("\(manga.url?.absoluteString ?? "N/A")", destination: manga.url ?? URL(string: "")!)
                    .padding(.bottom, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle(manga.title ?? "N/A")
        }
    }
}

#Preview {
    MangaDetailView(manga: .preview)
}
