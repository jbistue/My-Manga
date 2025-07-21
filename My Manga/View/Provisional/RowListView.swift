//
//  RowListView.swift
//  My Manga
//
//  Created by Javier Bistue on 21/7/25.
//

import SwiftUI

struct RowListView: View {
    
    let manga: Manga
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("# \(manga.id)")
                
                Text("**English title:** \(manga.titleEnglish ?? "-")")
            }
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.bottom, 2)
            
            Text("**Demographics**: \(manga.demographics.map { $0.demographic }.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("**Genres**: \(manga.genres.map { $0.genre }.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("**Themes**: \(manga.themes.map { $0.theme }.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("**Authors:** \(manga.authors.map { "\($0.firstName) \($0.lastName) (\($0.role))" }.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.gray.opacity(0.2)))
        .cornerRadius(10)
    }
}

#Preview {
    RowListView(manga: .test)
}
