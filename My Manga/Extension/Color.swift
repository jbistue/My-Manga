//
//  Color.swift
//  My Manga
//
//  Created by Javier Bistue on 12/9/25.
//

import SwiftUI

extension Color {
    init(r: Int, g: Int, b: Int, a: Double = 1.0) {
        self.init(.sRGB,
                  red: Double(r)/255,
                  green: Double(g)/255,
                  blue: Double(b)/255,
                  opacity: a)
    }
}
