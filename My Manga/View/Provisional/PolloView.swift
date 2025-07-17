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
//                            .onAppear {
//                                print("⬇️ --- Medido VStack ---")
//                                print("Altura VStack:", geo.size.height)
//                                print("Posición Y VStack:", geo.frame(in: .global).minY)
//                            }
                            .onChange(of: geo.frame(in: .global).minY) { oldValue, newValue in
                                let contentHeight = geo.size.height
                                let offsetY = geo.frame(in: .global).minY

                                let visibleBottom = contentHeight + offsetY
//                                print("Altura VStack:", contentHeight, "Visible Bottom:", visibleBottom.rounded())
                                if visibleBottom < screenHeight {
                                    let array2 = Array(array.count..<array.count+20)
                                    array.append(contentsOf: array2) // Simula cargar más datos
//                                    print("Altura VStack:", geo.size.height)
                                }
                            }
                    }
                )
            }
            .navigationTitle(Text("Pollos"))
//            .onAppear {
//                print("Altura pantalla:", screenHeight)
//            }
        }
        
    }
}

#Preview {
    PolloView()
}
