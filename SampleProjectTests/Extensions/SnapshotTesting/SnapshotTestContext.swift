import UIKit
import XCTest
import SnapshotTesting

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
        case .iPhone: "iPhone-\(appearance)"
        case .iPad: "iPad-\(appearance)"
        case .fixedSize: "FixedSize-\(appearance)"
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
