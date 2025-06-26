//
//  DemographicsView.swift
//  My Manga
//
//  Created by Javier Bistue on 25/6/25.
//

import SwiftUI

struct DemographicsView: View {
    @State private var model = MangaViewModel(repository: Repository())
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(model.demographics, id: \.self) { demographic in
                    NavigationLink(destination: Text(demographic)) {
                        Text(demographic)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Text("Demographics"))
            .task {
                await model.getDemographics()
            }
            .refreshable {
                await model.getDemographics()
            }
        }
    }
}

#Preview {
    DemographicsView()
}
