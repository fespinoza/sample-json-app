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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        CustomAsyncImage(viewData: viewData) { image in
            image
                .resizable()
        }
        .aspectRatio(340.0 / 510.0, contentMode: .fill)
        .offset(y: offset)
        .frame(maxWidth: .infinity)
        .frame(height: posterHeight)
        .clipped()
        .overlay {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: gradientStartLocation),
                    .init(color: gradientColor, location: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    var gradientStartLocation: CGFloat {
        dynamicTypeSize > .xxLarge ? 0.0 : 0.75
    }

    var posterHeight: CGFloat {
        horizontalSizeClass == .compact ? 450 : 600
    }

    var offset: CGFloat {
        horizontalSizeClass == .compact ? 60 : 300
    }
}

#Preview {
    MovieDetailPosterView(viewData: .image(.avatar2), gradientColor: .red)
        .background(Color.red)
        .frame(maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
}
