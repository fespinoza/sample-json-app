import Foundation

struct SimklClient {
    func trendingMovies() async throws -> [TrendingMovie] {
        let request = GetTrendingMoviesWeekRequest().urlRequest
        let urlSession = URLSession(configuration: .default)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode([TrendingMovie].self, from: data)
    }

    func movie(with id: SimklMovieID) async throws -> Movie {
        let request = GetMovieDetailsRequest(id: id).urlRequest
        let urlSession = URLSession(configuration: .default)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(Movie.self, from: data)
    }
}
