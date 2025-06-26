//
//  MangaDetailView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct MangaDetailView: View {
    @State private var model = MangaViewModel(repository: Repository())
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: model.manga?.mainPicture) { image in
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
                
                Text("**Title:** \(model.manga?.title ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**English title:** \(model.manga?.titleEnglish ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Japanese title:** \(model.manga?.titleJapanese ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Start:** \(model.manga?.startDate.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**End:** \(model.manga?.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Status:** \(model.manga?.status ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Chapters:** \(String(model.manga?.chapters ?? 0))")
                    .padding(.bottom, 2)
                Text("**Volumes:** \(String(model.manga?.volumes ?? 0))")
                    .padding(.bottom, 2)
                Text("**Score:** \(String(model.manga?.score ?? 0))")
                    .padding(.bottom, 2)
                Text("**Background:** \(model.manga?.background ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Synopsis:** \(model.manga?.sypnosis ?? "N/A")")
                    .padding(.bottom, 2)
                Text("**Themes:** \(model.manga?.themes.map { $0.theme }.joined(separator: ", ") ?? "No themes")")
                    .padding(.bottom, 2)
                Text("**Genres:** \(model.manga?.genres.map { $0.genre }.joined(separator: ", ") ?? "No genres")")
                    .padding(.bottom, 2)
                Text("**Demographics:** \(model.manga?.demographics.map { $0.demographic }.joined(separator: ", ") ?? "No demographics")")
                    .padding(.bottom, 2)
                Text("**Authors:** \(model.manga?.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.joined(separator: ", ") ?? "No authors")")
                    .padding(.bottom, 2)
                Text("**URL:** \(model.manga?.url?.absoluteString ?? "N/A")")
                    .padding(.bottom, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle("Manga Detail")
            .task {
                await model.getMangaDetail(id: 42)
            }
        }
    }
}

#Preview {
    MangaDetailView()
}
