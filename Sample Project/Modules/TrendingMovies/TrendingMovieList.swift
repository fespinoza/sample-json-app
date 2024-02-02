//
//  TrendingMovieList.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 30/01/2024.
//

import SwiftUI

struct TrendingMovieList: View {
    @State var movies: [MovieCellViewData] = []
    let client = Client()

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 100, maximum: 300)),
                        GridItem(.adaptive(minimum: 100, maximum: 300)),
                    ],
                    spacing: 12,
                    content: {
                        ForEach(movies) { movie in
//                            MovieCell(viewData: movie)
                            NavigationLink(destination: MovieContainerView(id: movie.id)) {

                            CustomAsyncImage(viewData: movie.image) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                                .frame(
                                    width: proxy.size.width / 2.0 - 16,
                                    height: (proxy.size.width / 2.0 - 16) * 1.5
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 4)
//                                .background(Color.red)
                            }
                        }
                    }
                )
                .padding(.horizontal, 8)

                //            LazyVGrid {
                //            }
            }
        }
        .navigationTitle("Trending Movies")
        .task {
            await fetchMovies()
        }
    }

    func fetchMovies() async {
        do {
            let movieList = try await client.fetchTrendingMovies()
            movies = movieList.map { MovieCellViewData(from: $0) }
        } catch {
            print(error)
        }
    }
}

#Preview {
    NavigationStack {
        TrendingMovieList()
    }
}
