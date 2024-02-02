//
//  Parser.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 01/02/2024.
//

import Foundation

extension MovieCellViewData {
    init(from movie: MovieData) {
        self.id = movie.id
        self.title = movie.title
        self.releaseYear = movie.releaseDate?
            .split(separator: "/")
            .last
            .flatMap { String($0) }
        self.duration = movie.runtime
        self.image = .remote(url: movie.imageURL)

//        print(movie.imageURL)
    }
}
