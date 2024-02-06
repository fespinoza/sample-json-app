import SwiftUI

struct MovieViewData {
    let id: SimklMovieID
    let title: String
    let image: ImageViewData
    let year: String
    let runtime: String?
    let overview: String
    let genres: [String]
    let rating: String
    let trailer: VideoViewData?
}

struct MovieDetailsView: View {
    let viewData: MovieViewData

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicSizeType

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                MovieDetailPosterView(viewData: viewData.image)
                    .padding(.horizontal, -16)
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 8) {
                            Text(viewData.title)
                                .font(.title.bold())
                                .shadow(radius: colorScheme == .dark ? 4 : 0)

                            Label(
                                title: { Text(viewData.rating) },
                                icon: {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            )

                            details
                        }
                    }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Overview")
                        .font(.headline)

                    Text(viewData.overview)
                }
                .frame(maxWidth: 560)

                if let trailer = viewData.trailer {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trailer")
                            .font(.headline)

                        ExternalVideoView(videoData: trailer)
                    }
                    .frame(maxWidth: 560)
                }
            }
            .padding(.bottom, 64)
            .padding(.horizontal, 16)
        }
        .navigationTitle(viewData.title)
    }

    @ViewBuilder var details: some View {
        if dynamicSizeType > .xxxLarge {
            VStack(alignment: .leading, spacing: 16) { detailContent }
                .font(.caption)
                .frame(maxWidth: .infinity)
        } else {
            HStack {
                detailContent
            }
            .font(.caption)
        }
    }

    @ViewBuilder var detailContent: some View {
        Label(viewData.year, systemImage: "calendar")

        if let runtime = viewData.runtime {
            Label(runtime, systemImage: "clock")
        }

        Label(viewData.genres.joined(separator: ", "), systemImage: "tag")
    }
}

#Preview {
    NavigationStack {
        MovieDetailsView(viewData: .previewValue())
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension MovieViewData {
    static func previewValue(
        id: SimklMovieID = .init((1...100).randomElement() ?? 3),
        title: String = "Avatar: The Way of Water",
        image: ImageViewData = .image(.avatar2),
        year: String = "2022",
        runtime: String? = "3h 12m",
        overview: String = """
        Set more than a decade after the events of the first \
        film, learn the story of the Sully family (Jake, Neytiri, \
        and their kids), the trouble that follows them, the \
        lengths they go to keep each other safe, the battles \
        they fight to stay alive, and the tragedies they endure.
        """,
        genres: [String] = [
            "Action",
            "Adventure",
            "Science Fiction",
            "War"
        ],
        rating: String = "7.7",
        trailer: VideoViewData? = .placeholder(color: .red)
    ) -> Self {
        .init(
            id: id,    
            title: title,    
            image: image,    
            year: year,    
            runtime: runtime,    
            overview: overview,    
            genres: genres,    
            rating: rating,
            trailer: trailer
        )
    }
}
