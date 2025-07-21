//
//  PolloView.swift
//  My Manga
//
//  Created by Javier Bistue on 15/7/25.
//

import SwiftUI

struct PolloView: View {
    @State var array = Array(0..<20)
    
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(array, id: \.self) { i in
                        NavigationLink(destination: Text("Detalle del ítem \(i)")) {
                            Text("Item \(i)")
                                .frame(height: 60)
                                .frame(maxWidth: .infinity)
                                .background(.blue.opacity(0.2))
                        }
                    }
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) { _, newValue in
                                let contentHeight = geo.size.height
                                let offsetY = newValue

                                let visibleBottom = contentHeight + offsetY

                                if visibleBottom < screenHeight {
                                    let array2 = Array(array.count..<array.count+20)
                                    array.append(contentsOf: array2) // Simula cargar más datos
                                }
                            }
                    }
                )
            }
            .navigationTitle(Text("Pollos"))
        }
        
    }
}

#Preview {
    PolloView()
}
