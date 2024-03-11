import Foundation

struct GetTrendingMoviesWeekRequest {
    let path = "movies/trending/week"

    var urlRequest: URLRequest {
        let url = ApiConstants
            .baseApiURL
            .appending(path: path)
            .appending(queryItems: [
                .init(name: "client_id", value: ApiConstants.clientID),
                .init(name: "extended", value: "title,slug,overview,metadata,theater,genres,tmdb")
            ])

        return URLRequest(url: url)
    }
}
