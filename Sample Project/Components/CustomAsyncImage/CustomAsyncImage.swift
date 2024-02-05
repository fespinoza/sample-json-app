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
        .transition(.opacity)
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
