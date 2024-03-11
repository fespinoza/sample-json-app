import SwiftUI

struct TrendingMovieViewData: Identifiable {
    let id: SimklMovieID
    let image: ImageViewData
}

extension TrendingMovieViewData {
    static func previewValue(image: ImageViewData = .image(.avatar2)) -> Self {
        .init(id: .init((1...200).randomElement() ?? 2), image: image)
    }
}

struct TrendingMovieList: View {
    @State var state: BasicLoadingState<[TrendingMovieViewData]> = .idle
    let client = SimklClient()

    var body: some View {
        Group {
            switch state {
            case .idle:
                Color.clear
            case .loading:
                ProgressView()
            case let .dataLoaded(movies):
                Content(movies: movies)
            case let .error(error):
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle("Trending Movies")
        .task { await fetchMoviesIfNeeded() }
    }

    func fetchMoviesIfNeeded() async {
        guard case .idle = state else { return }
        state = .loading

        do {
            let backendData = try await client.trendingMovies()
            let movies = backendData.map { TrendingMovieViewData(id: $0.id, image: .remote(url: $0.imageURL)) }
            state = .dataLoaded(movies)

        } catch {
            state = .error(error)
        }
    }
}

#Preview {
    NavigationStack {
        TrendingMovieList()
    }
}
