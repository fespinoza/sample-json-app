import SwiftUI
import SnapshotTesting
import XCTest
@testable import SampleProject

class MovieDetailsViewTests: XCTestCase {
    override func setUp() {
        SnapshotTesting.diffTool = "ksdiff"
    }

    func testView_iPhone_lightMode() {
        customAssertSnapshot(
            of: viewContainer(),
            as: .customImage(
                on: .iPhone13Pro,
                traits: UITraitCollection(userInterfaceStyle: .light)
            )
        )
    }

    func testView_iPhone_darkMode_ES() {
        customAssertSnapshot(
            of: viewContainer(locale: "es"),
            as: .customImage(on: .iPhone13Pro, traits: UITraitCollection(userInterfaceStyle: .dark))
        )
    }

    func testView_iPhone_lightMode_dynamicType() {
        customAssertSnapshot(
            of: viewContainer(),
            as: .customImage(
                on: .iPhone13Pro,
                traits: UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraLarge)
            )
        )
    }

    func testView_iPad_lightMode_NB() {
        customAssertSnapshot(of: viewContainer(locale: "nb"), as: .customImage(on: .iPadPro11(.portrait)))
    }

    func testView_fixedSize() {
        customAssertSnapshot(
            of: viewContainer(),
            as: .customImage(on: .iPhone13Pro, size: CGSize(width: 393, height: 1200))
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
