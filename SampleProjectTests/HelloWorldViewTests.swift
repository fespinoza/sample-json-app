import SwiftUI
import SnapshotTesting
import XCTest
@testable import SampleProject

class HelloWorldViewTests: XCTestCase {
    func testView() {
        let view = HelloWorldView()
        let controller = UIHostingController(rootView: view)
        customAssertSnapshot(of: controller, as: .image(on: .iPhone13Pro))
    }
}
