//
//  StoreFiltersButton.swift
//  My Manga
//
//  Created by Javier Bistue on 21/7/25.
//

import SwiftUI

struct StoreFiltersButton: ViewModifier {
    @Environment(MangaViewModel.self) var model

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu(model.menuLabel) {
                        Button(String(localized: "All")) {
                            model.menuLabel = String(localized: "All")
                            model.mangaFilter = "list/mangas"
                        }
                        
                        Menu(String(localized: "Demographics")) {
                            ForEach(model.demographics, id: \.self) { demographic in
                                Button(demographic) {
                                    model.menuLabel = "\(String(localized: "Demography")): \(demographic)"
                                    model.mangaFilter = "list/mangaByDemographic/\(demographic)"
                                }
                            }
                        }
                        
                        Menu(String(localized: "Genres")) {
                            ForEach(model.genres, id: \.self) { genre in
                                Button(genre) {
                                    model.menuLabel = "\(String(localized: "Genre")): \(genre)"
                                    model.mangaFilter = "list/mangaByGenre/\(genre)"
                                }
                            }
                        }
                        
                        Menu(String(localized: "Themes")) {
                            ForEach(model.themes, id: \.self) { theme in
                                Button(theme) {
                                    model.menuLabel = "\(String(localized: "Theme")): \(theme)"
                                    model.mangaFilter = "list/mangaByTheme/\(theme)"
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
        modifier(StoreFiltersButton())
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
