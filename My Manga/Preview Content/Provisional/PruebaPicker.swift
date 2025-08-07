//
//  PruebaPicker.swift
//  My Manga
//
//  Created by Javier Bistue on 31/7/25.
//

import Foundation
import SwiftUI

struct PruebaPicker: View {
    @State private var selectedVolumesToAdd: Set<Int> = []
    @State private var itemSelectedToRead: Int? = nil
    
    private let totalVolumesNumber = 909
    private let totalVolumes: [Int]
    private let ownedVolumes = [910, 911, 912, 913]
//    private let items = ["-", "# 1", "# 2", "# 3", "# 4", "# 5", "# 6", "# 7", "# 8", "# 9"]
    
    init() {
        self.totalVolumes = Array(900...totalVolumesNumber)
//        _itemSelectedToRead = State(initialValue: ownedVolumes.first ?? 0)
    }
    
    var allSelected: Bool {
        selectedVolumesToAdd.count == totalVolumes.count
    }
    
    var body: some View {
        Text("**Owned volumes:** \(ownedVolumes.map { String($0) }.formatted(.list(type: .and)))")
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        
        Text("**Pending volumes:** \(pendingVolumes().map { String($0) }.formatted(.list(type: .and)))")
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Select volumes to add:")
                    .font(.callout)
                
                Spacer()
                
                Button(allSelected ? "Deselect All" : "Select All") {
                    withAnimation {
                        if allSelected {
                            selectedVolumesToAdd.removeAll()
                        } else {
                            selectedVolumesToAdd = Set(totalVolumes)
                        }
                    }
                }
                .font(.subheadline)
                .padding(6)
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .cornerRadius(6)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 35))], spacing: 10) {
                ForEach(totalVolumes, id: \.self) { volume in
                    Button(action: {
                        if selectedVolumesToAdd.contains(volume) {
                            selectedVolumesToAdd.remove(volume)
                        } else {
                            selectedVolumesToAdd.insert(volume)
                        }
                    }) {
                        Text("\(volume)")
                            .font(.caption)
                            .frame(width: 35, height: 35)
                            .background(selectedVolumesToAdd.contains(volume) ? Color.accentColor : Color(.systemGray5))
                            .foregroundColor(selectedVolumesToAdd.contains(volume) ? .white : .primary)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.accentColor, lineWidth: selectedVolumesToAdd.contains(volume) ? 0 : 1)
                            )
                        }
                        .animation(.easeInOut(duration: 0.2), value: selectedVolumesToAdd)
                }
            }
        }
        .padding(.horizontal, 20)
        
        HStack {
            Text("Reading volume:")
                .font(.callout)
            
            Picker("Reading volume:", selection: $itemSelectedToRead) {
                Text("-").tag(Optional<Int>.none)
                ForEach(ownedVolumes, id: \.self) { item in
                    Text(String(item))
                        .tag(item)
                        .font(.callout)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 80)
            
            Button {
                itemSelectedToRead = nil
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.title2)
                    .fontWeight(.light)
            }
            
            Button {
                guard let current = itemSelectedToRead,
                      let index = ownedVolumes.firstIndex(of: current),
                      ownedVolumes.indices.contains(index + 1)
                else {
                    itemSelectedToRead = ownedVolumes.first
                    return
                }
                itemSelectedToRead = ownedVolumes[index + 1]
            } label: {
                Image(systemName: "chevron.forward.circle")
                    .font(.title2)
                    .fontWeight(.light)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        
        
//        Text("Selected: \(selectedItem ?? "None")")
        Text("Selected: \(itemSelectedToRead ?? 0)")
            .font(.headline)
    }
    
    func pendingVolumes() -> [Int] {
        let totalVolumesSet = Set(totalVolumes)
        let ownedVolumesSet = Set(ownedVolumes)
        let pendingVolumes = Array(totalVolumesSet.subtracting(ownedVolumesSet)).sorted(by: <)
        return pendingVolumes
    }
}

#Preview {
    PruebaPicker()
}
