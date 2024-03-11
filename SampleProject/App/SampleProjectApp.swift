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
