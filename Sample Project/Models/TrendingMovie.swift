import Foundation

struct TrendingMovie: Decodable, Identifiable {
    let ids: IDContainer
    let title: String
    let url: String
    let poster: String
    let fanart: String?
    let overview: String
    let releaseDate: String?
    let runtime: String?
    let genres: [String]

    var id: SimklMovieID { ids.simklID }

    struct IDContainer: Decodable {
        let simklID: SimklMovieID
        let slug: String

        enum CodingKeys: String, CodingKey {
            case simklID = "simkl_id"
            case slug
        }
    }

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case poster
        case fanart
        case overview
        case releaseDate = "release_date"
        case runtime
        case genres
        case ids
    }

    var imageURL: URL { ImageCdnURL.posterURL(for: poster) }

    var fanartImageURL: URL? {
        guard let fanart else { return nil }
        return ImageCdnURL.fanart(for: fanart)
    }
}
