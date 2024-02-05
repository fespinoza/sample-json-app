import SwiftUI
import SnapshotTesting
import XCTest
@testable import Sample_Project

class MovieDetailsViewTests: XCTestCase {
    func testView_iPhone_lightMode() {
        assertSnapshot(of: viewContainer(), as: .image(on: .iPhone13Pro))
    }

    func testView_iPhone_darkMode() {
        assertSnapshot(
            of: viewContainer(),
            as: .image(on: .iPhone13Pro, traits: UITraitCollection(userInterfaceStyle: .dark))
        )
    }

    func testView_fixedSize() {
        assertSnapshot(
            of: viewContainer(),
            as: .image(on: .iPhone13Pro, size: CGSize(width: 393, height: 1200))
        )
    }

    private func viewContainer() -> UIViewController {
        UIHostingController(
            rootView: NavigationStack {
                MovieDetailsView(viewData: .previewValue())
                    .navigationBarTitleDisplayMode(.inline)
            }
        )
    }
}
