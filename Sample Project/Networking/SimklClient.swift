import Foundation

struct SimklClient {
    func trendingMovies() async throws -> [TrendingMovie] {
        let request = GetTrendingMoviesWeekRequest().urlRequest
        let urlSession = URLSession(configuration: .default)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode([TrendingMovie].self, from: data)
    }
}
