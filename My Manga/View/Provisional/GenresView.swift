//
//  GenresView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct GenresView: View {
    @Environment(MangaViewModel.self) var model
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.genres, id: \.self) { gender in
                    NavigationLink(destination: Text(gender)) {
                        Text(gender)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Genres"))
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    GenresView()
        .task {
            model.loadInitialData()
        }
        .environment(model)
}
