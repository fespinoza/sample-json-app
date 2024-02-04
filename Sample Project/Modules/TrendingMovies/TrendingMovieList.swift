import SwiftUI

struct TrendingMovieList: View {
    @State var movies: [TrendingMovie] = []
    let client = SimklClient()

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
                            CustomAsyncImage(viewData: .remote(url: movie.imageURL)) { image in
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
                )
                .padding(.horizontal, 8)
            }
        }
        .navigationTitle("Trending Movies")
        .task { await fetchMovies() }
    }

    func fetchMovies() async {
        do {
            movies = try await client.trendingMovies()
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
