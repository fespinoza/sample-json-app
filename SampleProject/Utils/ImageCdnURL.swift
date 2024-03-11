import Foundation

struct ImageCdnURL {
    static func posterURL(for poster: String) -> URL {
        ApiConstants
            .imageBaseURL
            .appending(
                queryItems: [
                    .init(
                        name: "url",
                        value: ApiConstants
                            .imageContentBaseURL
                            .appending(path: "posters/\(poster)_m.jpg")
                            .absoluteString
                            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    )
                ]
            )
    }

    static func fanart(for fanart: String) -> URL {
        ApiConstants
            .imageBaseURL
            .appending(
                queryItems: [
                    .init(
                        name: "url",
                        value: ApiConstants
                            .imageContentBaseURL
                            .appending(path: "fanart/\(fanart)_mobile.jpg")
                            .absoluteString
                            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    )
                ]
            )
    }
}
