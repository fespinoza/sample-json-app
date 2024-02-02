//
//  Constants.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 30/01/2024.
//

import Foundation

struct BackendConstants {
    static let baseURL = URL(string: "https://api.simkl.com")!
    static let clientID: String = {
        Bundle.main.infoDictionary!["API_CLIENT_ID"] as! String
    }()
    static let imageBaseURL = URL(string: "https://wsrv.nl/")!
    static let imageContentBaseURL = URL(string: "https://simkl.in/")!
}

//https://api.simkl.com/movies/trending/week

struct TrendingMoviesWeek {
    let path = "movies/trending/week"

    var urlRequest: URLRequest {
        let url = BackendConstants
            .baseURL
            .appending(path: path)
            .appending(queryItems: [
                .init(name: "client_id", value: BackendConstants.clientID),
                .init(name: "extended", value: "title,slug,overview,metadata,theater,genres,tmdb")
            ])

        return URLRequest(url: url)
    }
}

struct GetMovieDetailRequest {
//https://api.simkl.com/movies/tt1201607
    let path = "movies"
    let id: MovieID

    var urlRequest: URLRequest {
        let url = BackendConstants
            .baseURL
            .appending(path: path)
            .appending(path: "\(id)")
            .appending(queryItems: [
                .init(name: "client_id", value: BackendConstants.clientID),
                .init(name: "extended", value: "full")
            ])

        return URLRequest(url: url)
    }
}

struct Client {
    func fetchTrendingMovies() async throws -> [MovieData] {
        let request = TrendingMoviesWeek().urlRequest
        return try await load(request: request)
    }

    func fetchMovie(id: MovieID) async throws -> Movie {
        let request = GetMovieDetailRequest(id: id).urlRequest
        print(request.url)
        return try await load(request: request)
    }

    private func load<Response: Decodable>(request: URLRequest) async throws -> Response {
        let urlSession = URLSession(configuration: .default)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

struct Movie: Decodable, Identifiable {
    let title: String
    let ids: MovieIDContainer
    let year: Int
    let poster: String
    let runtime: Int
    let overview: String
    let genres: [String]
    let director: String
    let raitings: Raiting
    let trailers: [Trailer]

    var id: MovieID { ids.simklID }

    var imageURL: URL {
        BackendConstants
            .imageBaseURL
            .appending(
                queryItems: [.init(
                    name: "url",
                    value: BackendConstants
                        .imageContentBaseURL
                        .appending(path: "posters/\(poster)_m.jpg")
                        .absoluteString
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )]
            )
    }

    struct Raiting: Decodable {
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

import Tagged

typealias MovieID = Tagged<MovieData, Int>

struct MovieIDContainer: Decodable {
    let simklID: MovieID
    let slug: String

    enum CodingKeys: String, CodingKey {
        case simklID = "simkl_id"
        case slug
    }
}

struct MovieData: Decodable, Identifiable {
    let ids: MovieIDContainer
    let title: String
    let url: String
    let poster: String
    let fanart: String?
    let overview: String
    let releaseDate: String?
    let runtime: String?
    let genres: [String]

    var id: MovieID { ids.simklID }

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

    var imageURL: URL {
        BackendConstants
            .imageBaseURL
            .appending(
                queryItems: [.init(
                    name: "url",
                    value: BackendConstants
                        .imageContentBaseURL
                        .appending(path: "posters/\(poster)_m.jpg")
                        .absoluteString
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )]
            )
    }

    var fanartImageURL: URL? {
        guard let fanart else { return nil }
        return BackendConstants
            .imageBaseURL
            .appending(
                queryItems: [.init(
                    name: "url",
                    value: BackendConstants
                        .imageContentBaseURL
                        .appending(path: "fanart/\(fanart)_mobile.jpg")
                        .absoluteString
                        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )]
            )
    }
}
