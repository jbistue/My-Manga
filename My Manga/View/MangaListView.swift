//
//  MangaListView.swift
//  My Manga
//
//  Created by Javier Bistue on 26/6/25.
//

import SwiftUI

struct MangaListView: View {
    @Environment(MangaViewModel.self) var model
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.mangas.items) { manga in
                    NavigationLink(destination: MangaDetailView(manga: manga)) {
                        Text("[#\(manga.id)] \(manga.title ?? "N/A")")
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Mangas"))
            .task {
                await model.getMangas()
            }
            .refreshable {
                await model.getMangas()
            }
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    MangaListView()
        .task {
            await model.getMangas()
        }
        .environment(model)
}
