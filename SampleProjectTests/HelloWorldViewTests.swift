import SwiftUI
import SnapshotTesting
import XCTest
@testable import SampleProject

class HelloWorldViewTests: XCTestCase {
    func testView() {
        let view = HelloWorldView()
        let controller = UIHostingController(rootView: view)
        assertIPhoneSnapshot(of: controller)
    }

    func testTraitsSetup() {
        
    }
}
