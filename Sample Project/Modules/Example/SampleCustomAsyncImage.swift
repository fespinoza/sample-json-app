//
//  SampleCustomAsyncImage.swift
//  Sample Project
//
//  Created by Felipe Espinoza on 28/01/2024.
//

import SwiftUI

enum ImageViewData {
    case placeholder
    case loading
    case image(_ image: Image)
    case remote(url: URL)
    case error

    static func image(_ resource: ImageResource) -> Self {
        .image(Image(resource))
    }

    static func remote(url: URL?) -> Self {
        if let url {
            .remote(url: url)
        } else {
            .placeholder
        }
    }
}

struct CustomFetchImage {
    let fetchImage: (URL) async throws -> Image

    func callAsFunction(_ url: URL) async throws -> Image {
        try await fetchImage(url)
    }

    static func basicLoad(url: URL) async throws -> Image {
        let (imageData, _) = try await URLSession.shared.data(from: url)
        guard let uiImage = UIImage(data: imageData) else { throw ImageError.decodeError }
        return Image(uiImage: uiImage)
    }

    enum ImageError: Error {
        case decodeError
    }
}

//https://swiftwithmajid.com/2019/08/21/the-power-of-environment-in-swiftui/

struct CustomFetchImageKey: EnvironmentKey {
    static var defaultValue: CustomFetchImage = .init(fetchImage: CustomFetchImage.basicLoad(url:))
}

extension EnvironmentValues {
    var fetchImage: CustomFetchImage {
        get { self[CustomFetchImageKey.self] }
        set { self[CustomFetchImageKey.self] = newValue }
    }
}

struct CustomAsyncImage<ImageContent: View>: View {
    @Environment(\.fetchImage) private var fetchImage

    @State var viewData: ImageViewData
    var transitionDelay: TimeInterval = 0
    var content: ((Image) -> ImageContent)?

    var body: some View {
        Group {
            switch viewData {
            case .placeholder:
                Color.gray
            case .loading, .remote:
                ProgressView()
            case let .image(image):
                if let content {
                    content(image)
                } else {
                    image
                }
            case .error:
                Color.red
            }
        }
        .task { await loadImageIfNeeded() }
    }

    func loadImageIfNeeded() async {
        guard case let .remote(imageUrl) = viewData else { return }

        withAnimation { viewData = .loading }

        do {
            let image = try await fetchImage(imageUrl)
            await delay(for: transitionDelay)
            withAnimation { viewData = .image(image) }
        } catch {
            await delay(for: transitionDelay)
            withAnimation { viewData = .placeholder }
        }
    }

    func delay(for timeInterval: TimeInterval) async {
        try? await Task.sleep(for: .seconds(timeInterval))
    }
}

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
