//
//  TrendingMovieList-Content.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 06/02/2024.
//

import SwiftUI

extension TrendingMovieList {
    struct Content: View {
        let movies: [TrendingMovieViewData]

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
                                NavigationLink(destination: MovieDetailsContainerView(id: movie.id)) {

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
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 8)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrendingMovieList.Content(
            movies: [
                .previewValue(),
                .previewValue(image: .image(.piratesOfTheCaribbean)),
                .previewValue(),
                .previewValue(),
                .previewValue(),
                .previewValue(),
                .previewValue(),
            ]
        )
        .navigationTitle("Trending Movies")
    }
}
