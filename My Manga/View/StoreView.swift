//
//  StoreView.swift
//  My Manga
//
//  Created by Javier Bistue on 9/7/25.
//

import SwiftUI

struct StoreView: View {
    @Environment(MangaViewModel.self) var model

    private let screenHeight = UIScreen.main.bounds.height
    let namespace: Namespace.ID

    init(namespace: Namespace.ID) {
        self.namespace = namespace
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(model.mangas) { manga in
                        NavigationLink(value: manga) {
                            CoverView(manga: manga, namespace: namespace)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onChange(of: proxy.frame(in: .global).minY) { oldValue, newValue in
                                let contentHeight = proxy.size.height
                                let offsetY = proxy.frame(in: .global).minY

                                let visibleBottom = contentHeight + offsetY

                                if visibleBottom < screenHeight + 700 {
                                    Task {
                                        await model.fetchMangas()
                                    }
                                }
                            }
                    }
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
//                            isFormPresented = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title3)
                        }
                    }
                }
            }
            .navigationTitle(Text("Store"))
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
                    .navigationTransition(.zoom(sourceID: "cover_\(manga.id)", in: namespace))
            }
        }
        .task {
            await model.fetchMangas()
//            await model.getMangas(page: 1, per: 90)
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    @Previewable @Namespace var namespace
    
    StoreView(namespace: namespace)
        .environment(model)
}
