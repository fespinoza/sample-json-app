import SwiftUI
import SnapshotTesting
import XCTest
@testable import SampleProject

class MovieDetailsViewTests: XCTestCase {
    func testView_iPhone_lightMode() {
        assertSnapshot(of: viewContainer(), as: .image(on: .iPhone13Pro))
    }

    func testView_iPhone_darkMode_ES() {
        assertSnapshot(
            of: viewContainer(locale: "es"),
            as: .image(on: .iPhone13Pro, traits: UITraitCollection(userInterfaceStyle: .dark))
        )
    }

    func testView_iPhone_lightMode_dynamicType() {
        assertSnapshot(
            of: viewContainer(),
            as: .image(
                on: .iPhone13Pro,
                traits: UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraLarge)
            )
        )
    }

    func testView_iPad_lightMode_NB() {
        assertSnapshot(of: viewContainer(locale: "nb"), as: .image(on: .iPadPro11(.portrait)))
    }

    func testView_fixedSize() {
        assertSnapshot(
            of: viewContainer(),
            as: .image(on: .iPhone13Pro, size: CGSize(width: 393, height: 1200))
        )
    }

    private func viewContainer(locale: String? = nil) -> UIViewController {
        let view = NavigationStack {
            MovieDetailsView(viewData: .previewValue())
                .navigationBarTitleDisplayMode(.inline)
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
