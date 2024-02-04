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

    var body: some View {
        ScrollView {
            VStack {
                CustomAsyncImage(viewData: viewData.image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .clipped()

                Text(viewData.title)
                    .font(.title.bold())

                Label(viewData.rating, systemImage: "star.fill")

                HStack {
                    Label(viewData.year, systemImage: "calendar")
                    if let runtime = viewData.runtime {
                        Label(runtime, systemImage: "clock")
                    }
                    Label(viewData.genres.joined(separator: ", "), systemImage: "tag")
                }
                .font(.caption)

                VStack(alignment: .leading) {
                    Text("Overview")
                        .font(.headline)

                    Text(viewData.overview)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    MovieDetailsView(viewData: .previewValue())
}

extension MovieViewData {
    static func previewValue(
        id: SimklMovieID = .init((1...100).randomElement() ?? 3),
        title: String = "Avatar: The Way of Water",
        image: ImageViewData = .image(.piratesOfTheCaribbean),
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
