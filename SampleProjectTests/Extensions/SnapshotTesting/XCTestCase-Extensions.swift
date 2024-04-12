import Foundation
import UIKit
import SnapshotTesting
import SwiftUI
import XCTest

extension XCTestCase {
    static var isRunningOnCI: Bool {
        ProcessInfo.processInfo.environment["CI"]?.lowercased() == "true"
    }

    /// the base url where the snapshots will be found
    static var snapshotsTestBaseUrl: URL {
        testBundleUrl
    }

    /// Returns the URL where the bundle is present
    ///
    /// Used to specify the location of the snapshot references on CI
    private static var testBundleUrl: URL {
        guard let url = Bundle.test.resourceURL else {
            fatalError("❌ we couldn't access to the test bundle URL")
        }
        return url
    }

    func assertIPhoneSnapshot(
        of controller: UIViewController,
        appearance: UIUserInterfaceStyle = .light,
        extraTraits: @escaping ((inout any UIMutableTraits) -> Void) = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: controller,
            in: .init(
                deviceType: .iPhone,
                appearance: appearance,
                extraTraits: extraTraits,
                file: file,
                testName: testName,
                line: line
            )
        )
    }

    func assertIPadSnapshot(
        of controller: UIViewController,
        appearance: UIUserInterfaceStyle = .light,
        extraTraits: @escaping ((inout any UIMutableTraits) -> Void) = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: controller,
            in: .init(
                deviceType: .iPad(.portrait),
                appearance: appearance,
                extraTraits: extraTraits,
                file: file,
                testName: testName,
                line: line
            )
        )
    }

    func assertFixedSizeSnapshot(
        of controller: UIViewController,
        width: CGFloat,
        height: CGFloat,
        appearance: UIUserInterfaceStyle = .light,
        extraTraits: @escaping ((inout any UIMutableTraits) -> Void) = { _ in },
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: controller,
            in: .init(
                deviceType: .fixedSize(.init(width: width, height: height)),
                appearance: appearance,
                extraTraits: extraTraits,
                file: file,
                testName: testName,
                line: line
            )
        )
    }

    private func assertSnapshot(
        of view: some View,
        in context: SnapshotTestContext
    ) {
        let controller = UIHostingController(rootView: NavigationStack { view })
        assertSnapshot(of: controller, in: context)
    }

    private func assertSnapshot(
        of viewController: UIViewController,
        in context: SnapshotTestContext
    ) {
        SnapshotTesting.diffTool = "ksdiff"

        let failure = SnapshotTesting.verifySnapshot(
            of: viewController,
            as: context.imageConfiguration,
            named: context.fileName,
            record: isRecording,
            file: context.file,
            testName: context.testName,
            line: context.line
        )

        guard let message = failure else { return }
        XCTFail(message, file: context.file, line: context.line)
    }
}
