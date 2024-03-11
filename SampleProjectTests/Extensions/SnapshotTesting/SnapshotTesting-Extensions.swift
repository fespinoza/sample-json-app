import Foundation
import UIKit
import SnapshotTesting
import XCTest

private class TestNamespace {}

extension Bundle {
    static var test: Bundle { Bundle(for: TestNamespace.self) }
}

extension XCTestCase {
    static var snapshotDiffTool: String? {
        ProcessInfo.processInfo.environment["SNAPSHOT_DIFF_TOOL"]
    }

    static var isRunningOnCI: Bool {
        ProcessInfo.processInfo.environment["SNAPSHOT_ON_CI"]?.lowercased() == "true"
    }

    /// the base url where the snapshots will be found
    static var snapshotsTestBaseUrl: URL {
        isRunningOnCI ? testBundleUrl : sourceCodeTestDirectory()
    }

    /// Returns the URL where the Test target source code is
    /// in relation to the location of this current file
    ///
    /// Used to specify the location of the snapshot references
    private static func sourceCodeTestDirectory(file: StaticString = #file) -> URL {
        // For local snapshot tests, we need to find the test target directory
        // We find this through the location of this current file
        // which was the only way I found to do it
        URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingPathExtension()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
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
}

extension ViewImageConfig {
    public static let iPhone15Pro = ViewImageConfig.iPhone15Pro(.portrait)

    /// Custom definition of the parameters of iPhone 15 Pro
    ///
    /// Values taken from: https://useyourloaf.com/blog/iphone-14-screen-sizes/
    ///
    /// - Parameter orientation: device orientation
    /// - Returns: config for snapshot test for the iPhone 15 Pro
    public static func iPhone15Pro(_ orientation: Orientation) -> ViewImageConfig {
        let safeArea: UIEdgeInsets
        let size: CGSize

        switch orientation {
        case .landscape:
            safeArea = .init(top: 0, left: 59, bottom: 21, right: 59)
            size = .init(width: 852, height: 393)
        case .portrait:
            safeArea = .init(top: 59, left: 0, bottom: 34, right: 0)
            size = .init(width: 393, height: 852)
        }

        return .init(safeArea: safeArea, size: size, traits: .iPhone13(orientation))
    }
}

extension UITraitCollection {
    /// Convenience to get a dark mode trait collection
    static let darkMode = UITraitCollection(userInterfaceStyle: .dark)

    /// Convenience to get a light mode trait collection
    static let lightMode = UITraitCollection(userInterfaceStyle: .light)

    static func iPhone15Pro(_ orientation: ViewImageConfig.Orientation) -> UITraitCollection {
        .iPhone13(orientation)
    }
}

struct SnapshotAppearance {
    let suffix: String
    let traits: UITraitCollection

    var isLightMode: Bool { suffix == "Light" }

    static let lightMode = SnapshotAppearance(suffix: "Light", traits: .lightMode)
    static let darkMode = SnapshotAppearance(suffix: "Dark", traits: .darkMode)
}

enum SnapshotDeviceType {
    case iPhone
    case iPad(_ orientation: ViewImageConfig.Orientation?)
    case fixedSize(_ size: CGSize)

    var viewConfig: ViewImageConfig {
        switch self {
        case .iPhone: .iPhone15Pro
        case .iPad(.none): .iPadPro11
        case let .iPad(.some(orientation)): .iPadPro11(orientation)
        case .fixedSize: .iPhone15Pro
        }
    }

    var size: CGSize? {
        guard case let .fixedSize(size) = self else {
            return nil
        }
        return size
    }

    var deviceTraits: UITraitCollection {
        switch self {
        case .iPhone: .iPhone15Pro(.portrait)
        case .iPad: .iPadPro11
        case .fixedSize: .iPhone15Pro(.portrait)
        }
    }
}

/// Encapsulates the full context for a snapshot test
struct SnapshotTestContext {
    let deviceType: SnapshotDeviceType
    let appearance: SnapshotAppearance
    let orientation: ViewImageConfig.Orientation?
    let extraTraits: UITraitCollection
    let precision: Float
    let perceptualPrecision: Float
    let file: StaticString
    let testName: String
    let line: UInt

    init(
        deviceType: SnapshotDeviceType,
        appearance: SnapshotAppearance,
        orientation: ViewImageConfig.Orientation? = nil,
        extraTraits: UITraitCollection = .init(),
        precision: Float = 0.98,
        perceptualPrecision: Float = 0.98,
        file: StaticString,
        testName: String,
        line: UInt
    ) {
        self.deviceType = deviceType
        self.appearance = appearance
        self.orientation = orientation
        self.extraTraits = extraTraits
        self.precision = precision
        self.perceptualPrecision = perceptualPrecision
        self.file = file
        self.testName = testName
        self.line = line
    }

    var imageConfiguration: Snapshotting<UIViewController, UIImage> {
        .image(
            on: deviceType.viewConfig,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            size: deviceType.size,
            traits: traits
        )
    }

    var fileName: String {
        switch deviceType {
        case .iPhone: "iPhone-\(appearance.suffix)"
        case .iPad: "iPad-\(appearance.suffix)"
        case .fixedSize: "FixedSize-\(appearance.suffix)"
        }
    }

    private var traits: UITraitCollection {
        UITraitCollection(
            traitsFrom: [
                appearance.traits,
                defaultTraits,
                deviceType.deviceTraits,
                extraTraits,
            ]
        )
    }

    private let defaultTraits = UITraitCollection(traitsFrom: [
        UITraitCollection(preferredContentSizeCategory: .large),
    ])

    var snapshotDirectory: String {
        XCTestCase.snapshotsTestBaseUrl.appending(path: "__Snapshots__/\(testClassName)").path()
    }

    private var testClassName: String {
        URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingPathExtension()
            .lastPathComponent
    }
}

import SwiftUI

extension XCTestCase {
    func assertIPhoneSnapshot(
        of controller: UIViewController,
        appearance: SnapshotAppearance = .lightMode,
        extraTraits: UITraitCollection = .init(),
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
        appearance: SnapshotAppearance = .lightMode,
        extraTraits: UITraitCollection = .init(),
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
        appearance: SnapshotAppearance = .lightMode,
        extraTraits: UITraitCollection = .init(),
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
        SnapshotTesting.diffTool = XCTestCase.snapshotDiffTool

        let failure = SnapshotTesting.verifySnapshot(
            of: viewController,
            as: context.imageConfiguration,
            named: context.fileName,
            record: isRecording,
            snapshotDirectory: context.snapshotDirectory,
            file: context.file,
            testName: context.testName,
            line: context.line
        )
        guard let message = failure else { return }
        XCTFail(message, file: context.file, line: context.line)
    }
}
