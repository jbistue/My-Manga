//
//  ThemesView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct ThemesView: View {
    @Environment(MangaViewModel.self) var model
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.themes, id: \.self) { theme in
                    NavigationLink(destination: Text(theme)) {
                        Text(theme)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Themes"))
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    ThemesView()
        .task {
            model.loadInitialData()
        }
        .environment(model)
}
