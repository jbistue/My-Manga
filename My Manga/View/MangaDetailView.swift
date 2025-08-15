//
//  MangaDetailView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct MangaDetailView: View {
    @State private var isFormPresented: Bool = false
    @State private var presentedLibraryItem: LibraryItemDB?
    
    let manga: Manga
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                MangaImageView(url: manga.mainPicture)
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(minHeight: 150, maxHeight: 400, alignment: .center)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
                    .padding(.bottom, 20)

                mangaDetails
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle(manga.title ?? "N/A")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isFormPresented = true
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $isFormPresented) {
                CollectionManagementView(mangaItem: manga)
            }
        }
    }
    
    private var mangaDetails: some View {
        Group {
            Text("**English title:** \(manga.titleEnglish ?? "-")")
                .padding(.bottom, 2)
            Text("**Japanese title:** \(manga.titleJapanese ?? "-")")
                .padding(.bottom, 2)
            Text("**Start:** \(manga.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "-")")
                .padding(.bottom, 2)
            Text("**End:** \(manga.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "-")")
                .padding(.bottom, 2)
            Text("**Status:** \(manga.status.description)")
                .padding(.bottom, 2)
            Text("**Chapters:** \(manga.chapters.map { "\($0)" } ?? "-")")
                .padding(.bottom, 2)
            Text("**Volumes:** \(manga.volumes.map { "\($0)" } ?? "-")")
                .padding(.bottom, 2)
            Text("**Score:** \(String(manga.score ?? 0.0))")
                .padding(.bottom, 2)
            Text("**Background:** \(manga.background ?? "-")")
                .padding(.bottom, 2)
            Text("**Synopsis:** \(manga.sypnosis ?? "-")")
                .padding(.bottom, 2)
            Text("**Themes:** \(manga.themes.map { $0.theme }.formatted(.list(type: .and)))")
                .padding(.bottom, 2)
            Text("**Genres:** \(manga.genres.map { $0.genre }.formatted(.list(type: .and)))")
                .padding(.bottom, 2)
            Text("**Demographics:** \(manga.demographics.map { $0.demographic }.formatted(.list(type: .and)))")
                .padding(.bottom, 2)
            Text("**Authors:** \(manga.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.formatted(.list(type: .and)))")
                .padding(.bottom, 2)
            Link("\(manga.url?.absoluteString ?? "-")", destination: manga.url ?? URL(string: "")!)
                .padding(.bottom, 2)
        }
    }
}

#Preview {
    MangaDetailView(manga: .test)
}
