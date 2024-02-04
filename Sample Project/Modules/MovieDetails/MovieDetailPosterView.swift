//
//  MovieDetailPosterView.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 04/02/2024.
//

import SwiftUI

struct MovieDetailPosterView: View {
    let viewData: ImageViewData

    var body: some View {
        CustomAsyncImage(viewData: viewData) { image in
            image
                .resizable()
        }
        .aspectRatio(340.0 / 510.0, contentMode: .fill)
        .offset(y: 60)
        .frame(height: 450)
        .clipped()
    }
}

#Preview {
    MovieDetailPosterView(viewData: .image(.avatar2))
}
