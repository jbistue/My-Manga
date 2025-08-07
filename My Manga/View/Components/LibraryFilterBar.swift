//
//  LibraryFilterBar.swift
//  My Manga
//
//  Created by Javier Bistue on 4/8/25.
//

import SwiftUI

enum LibraryFilter: String, CaseIterable, Identifiable {
    case all
    case reading
    case complete
    case incomplete
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .all: String(localized: "All")
        case .reading: String(localized: "Reading")
        case .complete: String(localized: "Complete")
        case .incomplete: String(localized: "Incomplete")
        }
    }
}

struct LibraryFilterBar: View {
    @Binding var libraryFilter: LibraryFilter
    
    var body: some View {
        HStack {
            ForEach(LibraryFilter.allCases) { option in
                Button(action: {
                    libraryFilter = option
                }) {
                    Text(option.description)
                        .font(.footnote)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(libraryFilter == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                .foregroundColor(libraryFilter == option ? .blue : .gray)
                .animation(.easeInOut, value: libraryFilter)
            }
        }
        .padding(.bottom, 14)
    }
}

#Preview {
    @Previewable @State var libraryFilter: LibraryFilter = .reading

    List {
        Section {
            Text(libraryFilter.description)
        } header: {
            LibraryFilterBar(libraryFilter: $libraryFilter)
                .textCase(nil)
        }
    }
}
