//
//  PolloView.swift
//  My Manga
//
//  Created by Javier Bistue on 15/7/25.
//

import SwiftUI

struct PolloView: View {
    @State private var array = Array(0..<20)
    @State private var showScrollToTopButton = false
    @State private var searchText = ""

    private let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear
                        .frame(height: 0)
                        .id("top")

                    LazyVStack {
                        ForEach(array, id: \.self) { i in
                            NavigationLink(destination: Text("Detalle del ítem \(i)")) {
                                Text("Item \(i)")
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .background(.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { _, newValue in
                                    let contentHeight = geo.size.height
                                    let offsetY = newValue
                                    let visibleBottom = contentHeight + offsetY

                                    if visibleBottom < screenHeight {
                                        let array2 = Array(array.count..<array.count+20)
                                        array.append(contentsOf: array2)
                                    }
                                }
                        }
                    )
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { _, newY in
                                    withAnimation {
                                        showScrollToTopButton = newY < -100
                                    }
                                }
                        }
                    )
                }
                .navigationTitle("Pollos")
                .searchable(text: $searchText, prompt: String(localized: "Search by title"))
                .overlay(alignment: .bottomTrailing) {
                    if showScrollToTopButton {
                        Button(action: {
                            withAnimation {
                                proxy.scrollTo("top", anchor: .top)
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .blue)
                                .font(.system(size: 40))
                                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 4)
                        }
                        .padding()
                        .transition(.scale)
                    }
                }
            }
        }
    }
}

#Preview {
    PolloView()
}
