//
//  MangasView.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

struct MangasView: View {
    @Environment(MangaViewModel.self) var model
//    @Query private var movies: [Movie]
//    let libraryItems: [LibraryItem] // = []
//    let detailsDict: [Int: Manga] // = []
    let namespace: Namespace.ID
//    
//    init(predicate: Predicate<LibraryItem>, namespace: Namespace.ID) {
//    init(predicate: Predicate<Manga>, namespace: Namespace.ID) {
    init(namespace: Namespace.ID) {
        self.namespace = namespace
//        
//        mangas = loadLibraryItems()
//        _movies = Query(filter: predicate, sort: [SortDescriptor<Movie>(\.title)])
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(model.mangas.items) { manga in
                            //                ForEach(libraryItems) { manga in
                            //                    NavigationLink(destination: MangaDetailView(manga: manga)) {
                            NavigationLink(value: manga) {
                                //                        CoverView(manga: manga)
                                CoverView(manga: manga, namespace: namespace)
                                //                        CoverView(manga: detailsDict[manga.id]!, namespace: namespace)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .task {
                        await model.getMangas()
                    }
                }
            }
            .safeAreaPadding()
            //        .animation(.easeInOut, value: selectedMovieType)
            //        .navigationTitle(Text(selectedMovieType.rawValue))
                    .navigationTitle(Text("Mangas"))
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
                    .navigationTransition(.zoom(sourceID: "cover_\(manga.id)", in: namespace))
            }
        }
    }
}

#Preview {
//    @Previewable @Namespace var namespace
//    MangasView(predicate: #Predicate<Manga> { $0.volumes ?? 0 > 0 }, namespace: namespace)
//    MangasView(libraryItems: PreviewRepository().loadLibraryItems(),
//               detailsDict: PreviewRepository().getDetailsMangaLibraryDict(),
//               namespace: namespace)
    @Previewable @State var model = MangaViewModel()
    @Previewable @Namespace var namespace
    
    MangasView(namespace: namespace)
        .task {
            await model.getMangas()
        }
        .environment(model)
}
