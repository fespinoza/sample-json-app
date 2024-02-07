import Foundation

struct GetMovieDetailsRequest {
    let path = "movies"
    let id: SimklMovieID

    var urlRequest: URLRequest {
        let url = ApiConstants
            .baseApiURL
            .appending(path: path)
            .appending(path: "\(id)")
            .appending(queryItems: [
                .init(name: "client_id", value: ApiConstants.clientID),
                .init(name: "extended", value: "full")
            ])

        return URLRequest(url: url)
    }
}
