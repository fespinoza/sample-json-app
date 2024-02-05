//
//  MovieDetailPosterView.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 04/02/2024.
//

import SwiftUI

struct MovieDetailPosterView: View {
    let viewData: ImageViewData
    var gradientColor: Color = Color(uiColor: .systemBackground)

    var body: some View {
        CustomAsyncImage(viewData: viewData) { image in
            image
                .resizable()
        }
        .aspectRatio(340.0 / 510.0, contentMode: .fill)
        .offset(y: 60)
        .frame(maxWidth: .infinity)
        .frame(height: 450)
        .clipped()
        .overlay {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.75),
                    .init(color: gradientColor, location: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    MovieDetailPosterView(viewData: .loading, gradientColor: .red)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
}
