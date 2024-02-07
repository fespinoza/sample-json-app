import SwiftUI

extension TrendingMovieList {
    struct Content: View {
        let movies: [TrendingMovieViewData]

        var columns: [GridItem] {
            [
                GridItem(.flexible(minimum: 100, maximum: 300)),
                GridItem(.flexible(minimum: 100, maximum: 300)),
            ]
        }

        var body: some View {
            GeometryReader { proxy in
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        spacing: 12,
                        content: {
                            ForEach(movies) { movie in
                                CustomAsyncImage(viewData: movie.image) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .clipped()
                                .shadow(radius: 4)
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
