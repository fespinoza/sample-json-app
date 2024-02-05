import SwiftUI
import WebKit

enum VideoViewData {
    case url(remoteUrl: URL)
    case placeholder(color: Color)
}

struct ExternalVideoView: View {
    let videoData: VideoViewData
    var allowsInlineMediaPlayback: Bool = true

    var body: some View {
        switch videoData {
        case let .url(videoUrl):
            WKWebViewAdapter(
                url: videoUrl,
                placeholderColor: .gray,
                allowsInlineMediaPlayback: allowsInlineMediaPlayback
            )
            .aspectRatio(16.0 / 9.0, contentMode: .fit)
        case let .placeholder(color):
            color
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
        }
    }
}

#Preview {
    VStack {
        ExternalVideoView(
            videoData: .url(remoteUrl: URL(string: "https://www.youtube.com/embed/QhyHBMlZBn8?si=1nW9ElRLwF2eTZD4")!)
        )

        ExternalVideoView(
            videoData: .placeholder(color: .red)
        )
    }
}

private struct WKWebViewAdapter: UIViewRepresentable {
    let url: URL
    let placeholderColor: UIColor
    let allowsInlineMediaPlayback: Bool

    init(url: URL, placeholderColor: UIColor = .gray, allowsInlineMediaPlayback: Bool = true) {
        self.url = url
        self.placeholderColor = placeholderColor
        self.allowsInlineMediaPlayback = allowsInlineMediaPlayback
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = allowsInlineMediaPlayback
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.load(URLRequest(url: url))
        webView.backgroundColor = placeholderColor
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

