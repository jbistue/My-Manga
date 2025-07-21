//
//  DemographicsView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct DemographicsView: View {
    @Environment(MangaViewModel.self) var model
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.demographics, id: \.self) { demographic in
                    NavigationLink(destination: Text(demographic)) {
                        Text(demographic)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Demographics"))
        }
    }
}

#Preview {
    @Previewable @State var model = MangaViewModel()
    
    DemographicsView()
        .task {
            model.loadMangaClassifications()
        }
        .environment(model)
}
