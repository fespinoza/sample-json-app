//
//  MovieDetails.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 01/02/2024.
//

import SwiftUI

enum BasicLoadingState<DataType> {
    case idle
    case loading
    case dataLoaded(_ data: DataType)
    case error(_ error: Error)
}

struct MovieContainerView: View {
    let id: MovieID
    @State var state: BasicLoadingState<Movie> = .idle

    var body: some View {
        Group {
            switch state {
            case .idle, .loading:
                ProgressView()
            
            case .dataLoaded(let data):
                MovieDetailsView(
                    viewData: .init(
                        id: data.id,
                        title: data.title,
                        releaseYear: data.year.formatted(),
                        duration: nil,
                        image: .remote(url: data.imageURL)
                    )
                )
            
            case let .error(error):
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
        }
        .task {
            await fetchMovie()
        }
    }

    private func fetchMovie() async {
        do {
            let data = try await Client().fetchMovie(id: id)
            state = .dataLoaded(data)
        } catch {
            dump(error)
            state = .error(error)
        }
    }
}

struct MovieDetailsView: View {
    let viewData: MovieCellViewData

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    MovieDetailsView(viewData: .previewValue())
}
