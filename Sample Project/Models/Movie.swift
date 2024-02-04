import Foundation

struct Movie: Decodable, Identifiable {
    let ids: IDContainer
    let title: String
    let year: Int
    let poster: String
    let runtime: Int?
    let overview: String
    let genres: [String]
    let director: String
    let ratings: Rating
    let trailers: [Trailer]?

    var id: SimklMovieID { ids.simkl }
    var imageURL: URL { ImageCdnURL.posterURL(for: poster) }
}

extension Movie {
    struct IDContainer: Decodable {
        let simkl: SimklMovieID
        let slug: String
    }

    struct Rating: Decodable {
        let simkl: SimklRating

        struct SimklRating: Decodable {
            let rating: Double
            let votes: Int
        }
    }

    struct Trailer: Decodable {
        let name: String
        let youtube: String
        let size: Int
    }
}
