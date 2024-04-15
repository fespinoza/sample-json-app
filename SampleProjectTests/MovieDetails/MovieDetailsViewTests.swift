import SwiftUI
import SnapshotTesting
import XCTest
@testable import SampleProject

class MovieDetailsViewTests: XCTestCase {
    func testView_iPhone_lightMode() {
        customAssertSnapshot(of: viewContainer(), as: .image(on: .iPhone13Pro, perceptualPrecision: 0.98))
    }

    func testView_iPhone_darkMode_ES() {
        customAssertSnapshot(
            of: viewContainer(locale: "es"),
            as: .image(
                on: .iPhone13Pro,
                perceptualPrecision: 0.98,
                traits: UITraitCollection(userInterfaceStyle: .dark)
            )
        )
    }

    func testView_iPhone_lightMode_dynamicType() {
        customAssertSnapshot(
            of: viewContainer(),
            as: .image(
                on: .iPhone13Pro, 
                perceptualPrecision: 0.98,
                traits: UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraLarge)
            )
        )
    }

    func testView_iPad_lightMode_NB() {
        customAssertSnapshot(
            of: viewContainer(locale: "nb"),
            as: .image(on: .iPadPro11(.portrait), perceptualPrecision: 0.98)
        )
    }

    func testView_fixedSize() {
        customAssertSnapshot(
            of: viewContainer(),
            as: .image(on: .iPhone13Pro, perceptualPrecision: 0.98, size: CGSize(width: 393, height: 1200))
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
