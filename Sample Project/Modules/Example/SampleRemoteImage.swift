//
//  SampleRemoteImage.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 28/01/2024.
//

import SwiftUI

struct SampleRemoteImage: View {
    let url = URL(string: "https://media.npr.org/assets/img/2023/01/14/this-is-fine_custom-dcb93e90c4e1548ffb16978a5a8d182270c872a9.jpg")

    var body: some View {
        VStack {
            Text("Hello, World!")

            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 300, height: 150)
            .background(Color.blue)
        }

    }
}

#Preview {
    SampleRemoteImage()
}
