//
//  SampleProjectApp.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 27/01/2024.
//

import SwiftUI

@main
struct SampleProjectApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TrendingMovieList()
            }
        }
    }
}
