//
//  MangaFiltersButton.swift
//  My Manga
//
//  Created by Javier Bistue on 21/7/25.
//

import SwiftUI

struct MangaFiltersButton: ViewModifier {
    @Environment(MangaViewModel.self) var model

    @State var menuLabel = String(localized: "All")
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(menuLabel) {
                        Button(String(localized: "All")) {
                            menuLabel = String(localized: "All")
                            model.mangaFilter = "mangas"
                        }
                        
                        Menu(String(localized: "Demographics")) {
                            ForEach(model.demographics, id: \.self) { demographic in
                                Button(demographic) {
                                    menuLabel = "\(String(localized: "Demographics:")) \(demographic)"
                                    model.mangaFilter = "mangaByDemographic/\(demographic)"
                                }
                            }
                        }
                        
                        Menu(String(localized: "Genres")) {
                            ForEach(model.genres, id: \.self) { gender in
                                Button(gender) {
                                    menuLabel = "\(String(localized: "Genres:")) \(gender)"
                                    model.mangaFilter = "mangaByGenre/\(gender)"
                                }
                            }
                        }
                        
                        Menu(String(localized: "Themes")) {
                            ForEach(model.themes, id: \.self) { theme in
                                Button(theme) {
                                    menuLabel = "\(String(localized: "Themes:")) \(theme)"
                                    model.mangaFilter = "mangaByTheme/\(theme)"
                                }
                            }
                        }
                    }
                }
            }
    }
}

extension View {
    func mangaFiltersButton() -> some View {
        modifier(MangaFiltersButton())
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    NavigationStack {
        List {
            Text(String(model.mangaFilter))
        }
        .mangaFiltersButton()
    }
    .task {
        model.loadMangaClassifications()
    }
    .environment(model)
}
