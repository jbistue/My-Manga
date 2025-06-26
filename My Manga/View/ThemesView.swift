//
//  ThemesView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct ThemesView: View {
    @State private var model = MangaViewModel(repository: Repository())
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.themes, id: \.self) { theme in
                    NavigationLink(destination: Text(theme)) {
                        Text(theme)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Themes"))
            .task {
                await model.getThemes()
            }
            .refreshable {
                await model.getThemes()
            }
        }
    }
}

#Preview {
    ThemesView()
}
