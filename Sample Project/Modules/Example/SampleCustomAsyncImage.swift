import SwiftUI

struct SampleCustomAsyncImage: View {
    @State var testCase: ImageTestCase = .image
    var imageViewData: ImageViewData {
        switch testCase {
        case .image: .image(testImage)
        case .loading: .loading
        case .error: .error
        case .remote: .remote(url: testUrl)
        case .placeholder: .placeholder
        }
    }

    let testUrl = URL(string: "https://media.npr.org/assets/img/2023/01/14/this-is-fine_custom-dcb93e90c4e1548ffb16978a5a8d182270c872a9.jpg")!
    let testImage = Image(.thisIsFine)

    enum ImageTestCase: String, Hashable {
        case image
        case loading
        case error
        case remote
        case placeholder
    }

    var body: some View {
        VStack {
            Text("Hello, World!")

            CustomAsyncImage(viewData: imageViewData, transitionDelay: 2) { image in
                image
                    .resizable()
            }
            .frame(width: 300, height: 150)
            .id(testCase.rawValue)

            Picker("Test Case", selection: $testCase) {
                Text(ImageTestCase.image.rawValue).tag(ImageTestCase.image)
                Text(ImageTestCase.loading.rawValue).tag(ImageTestCase.loading)
                Text(ImageTestCase.error.rawValue).tag(ImageTestCase.error)
                Text(ImageTestCase.remote.rawValue).tag(ImageTestCase.remote)
                Text(ImageTestCase.placeholder.rawValue).tag(ImageTestCase.placeholder)
            }

        }
    }
}

#Preview {
    SampleCustomAsyncImage()
}
