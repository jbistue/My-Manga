//
//  AuthorsView.swift
//  My Manga
//
//  Created by Javier Bistue on 3/7/25.
//

import SwiftUI

struct AuthorsView: View {
    @Environment(MangaViewModel.self) var model
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.authors, id: \.self) { author in
                    NavigationLink(destination: Text(author.firstName + " " + author.lastName)) {
                        Text("\(author.lastName), \(author.firstName) *(\(author.role))*")
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Authors"))
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    AuthorsView()
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}
