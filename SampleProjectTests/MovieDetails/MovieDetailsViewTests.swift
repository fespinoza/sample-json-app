import SwiftUI
import SnapshotTesting
import XCTest
@testable import SampleProject

class MovieDetailsViewTests: XCTestCase {
    func testView_iPhone_lightMode() {
        assertIPhoneSnapshot(of: viewContainer())
    }

    func testView_iPhone_darkMode_ES() {
        assertIPhoneSnapshot(of: viewContainer(locale: "es"), appearance: .dark)
    }

    func testView_iPhone_lightMode_dynamicType() {
        assertIPhoneSnapshot(
            of: viewContainer(),
            extraTraits: { mutableTraits in
                mutableTraits.preferredContentSizeCategory = .accessibilityExtraExtraLarge
            }
        )
    }

    func testView_iPad_lightMode_NB() {
        assertIPadSnapshot(of: viewContainer(locale: "nb"))
    }

    func testView_fixedSize() {
        assertFixedSizeSnapshot(of: viewContainer(), width: 393, height: 1200)
    }

    private func viewContainer(locale: String? = nil) -> UIViewController {
        let view = NavigationStack {
            MovieDetailsView(viewData: .previewValue())
                .navigationBarTitleDisplayMode(.inline)
                .lineSpacing(8)
        }

        return if let locale {
            UIHostingController(
                rootView: view.environment(\.locale, .init(identifier: locale))
            )
        } else {
            UIHostingController(rootView: view)
        }
    }
}
