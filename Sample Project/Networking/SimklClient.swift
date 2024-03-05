import Foundation

struct SimklClient {
    func trendingMovies() async throws -> [TrendingMovie] {
        let request = GetTrendingMoviesWeekRequest().urlRequest
        return try await load(request)
    }

    func movie(with id: SimklMovieID) async throws -> Movie {
        let request = GetMovieDetailsRequest(id: id).urlRequest
        return try await load(request)
    }

    private func load<RequestData: Decodable>(_ request: URLRequest) async throws -> RequestData {
        let urlSession = URLSession(configuration: .default)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(RequestData.self, from: data)
    }
}
