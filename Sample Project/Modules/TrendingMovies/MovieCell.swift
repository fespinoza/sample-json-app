//
//  MovieCell.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 01/02/2024.
//

import SwiftUI

struct MovieCellViewData: Identifiable {
    let id: MovieID
    let title: String
    let releaseYear: String?
    let duration: String?
    let image: ImageViewData
}

struct MovieCell: View {
    let viewData: MovieCellViewData

    var body: some View {
        VStack {
            CustomAsyncImage(viewData: viewData.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
//            .frame(width: 170, height: 250) // vertical
            .clipped()
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        MovieCell(viewData: .previewValue())
    }
    .padding()
}

extension MovieCellViewData {
    static func previewValue(
        id: MovieID = .init(1234),
        title: String = "Avatar: Way of the Water",
        releaseYear: String = "2022",
        duration: String = "3h 20m",
        image: ImageViewData = .image(.thisIsFine)
    ) -> Self {
        .init(
            id: id,
            title: title,
            releaseYear: releaseYear,
            duration: duration,
            image: image
        )
    }
}
