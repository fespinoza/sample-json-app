import SwiftUI

enum BasicLoadingState<DataType> {
    case idle
    case loading
    case dataLoaded(_ data: DataType)
    case error(_ error: Error)
}

struct MovieDetailsContainerView: View {
    let id: SimklMovieID
    @State var state: BasicLoadingState<MovieViewData> = .idle
    let client: SimklClient = .init()

    var body: some View {
        Group {
            switch state {
            case .idle:
                Color.clear

            case .loading:
                ProgressView()

            case let .dataLoaded(movie):
                MovieDetailsView(viewData: movie)

            case let .error(error):
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
        }
        .task {
            await fetchMovie()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func movieViewData(from movie: Movie) -> MovieViewData {
        let runtime: String?

        if let runtimeValue = movie.runtime {
            let runtimeInSeconds: TimeInterval = Double(runtimeValue) * 60
            let formatter = DateComponentsFormatter()

            formatter.unitsStyle = .abbreviated
            formatter.allowedUnits = [.hour, .minute]

            runtime = formatter.string(from: runtimeInSeconds)
        } else {
            runtime = nil
        }

        return .init(
            id: movie.id,
            title: movie.title,
            image: .remote(url: movie.imageURL),
            year: "\(movie.year)",
            runtime: runtime,
            overview: movie.overview,
            genres: movie.genres,
            rating: movie.ratings.simkl.rating.formatted(.number.precision(.significantDigits(2)))
        )
    }

    private func fetchMovie() async {
        do {
            let data = try await client.movie(with: id)
            let movie = movieViewData(from: data)
            state = .dataLoaded(movie)
        } catch {
            state = .error(error)
            dump(error)
        }
    }
}

#Preview {
    MovieDetailsContainerView(id: .init(162400))
}
