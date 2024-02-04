import SwiftUI

struct MovieViewData {
    let id: SimklMovieID
    let title: String
    let image: ImageViewData
    let year: String
    let runtime: String
    let overview: String
    let genres: [String]
    let rating: String
}

struct MovieDetailsView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    MovieDetailsView()
}

extension MovieViewData {
    static func previewValue(
        id: SimklMovieID = .init((1...100).randomElement() ?? 3),
        title: String = "Avatar: The Way of Water",
        image: ImageViewData = .image(.piratesOfTheCaribbean),
        year: String = "2022",
        runtime: String = "3h 12m",
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
