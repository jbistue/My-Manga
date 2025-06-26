//
//  GenresView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct GenresView: View {
    @State private var model = MangaViewModel(repository: Repository())
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.genres, id: \.self) { gender in
                    NavigationLink(destination: Text(gender)) {
                        Text(gender)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Genres"))
            .task {
                await model.getGenres()
            }
            .refreshable {
                await model.getGenres()
            }
        }
    }
}

#Preview {
    GenresView()
}
