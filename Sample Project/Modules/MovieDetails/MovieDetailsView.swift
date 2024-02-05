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
}

struct MovieDetailsView: View {
    let viewData: MovieViewData

    @Environment(\.colorScheme) private var colorScheme

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

                            Label(viewData.rating, systemImage: "star.fill")

                            HStack {
                                Label(viewData.year, systemImage: "calendar")
                                
                                if let runtime = viewData.runtime {
                                    Label(runtime, systemImage: "clock")
                                }
                                
                                Label(viewData.genres.joined(separator: ", "), systemImage: "tag")
                            }
                            .font(.caption)
                        }
                    }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Overview")
                        .font(.headline)

                    Text(viewData.overview)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .navigationTitle(viewData.title)
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
        rating: String = "7.7"
    ) -> Self {
        .init(
            id: id,    
            title: title,    
            image: image,    
            year: year,    
            runtime: runtime,    
            overview: overview,    
            genres: genres,    
            rating: rating   
        )
    }
}
