import UIKit
import XCTest
import SnapshotTesting

/// Encapsulates the full context for a snapshot test
struct SnapshotTestContext {
    let deviceType: SnapshotDeviceType
    let appearance: UIUserInterfaceStyle
    let orientation: ViewImageConfig.Orientation?
    let extraTraits: ((inout any UIMutableTraits) -> Void)
    let precision: Float
    let perceptualPrecision: Float
    let file: StaticString
    let testName: String
    let line: UInt

    init(
        deviceType: SnapshotDeviceType,
        appearance: UIUserInterfaceStyle,
        orientation: ViewImageConfig.Orientation? = nil,
        extraTraits: @escaping ((inout any UIMutableTraits) -> Void) = { _ in },
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
        case .iPhone: "iPhone-\(appearanceName)"
        case .iPad: "iPad-\(appearanceName)"
        case .fixedSize: "FixedSize-\(appearanceName)"
        }
    }

    private var appearanceName: String {
        switch appearance {
        case .unspecified:
            "Unspecified"
        case .light:
            "Light"
        case .dark:
            "Dark"
        @unknown default:
            fatalError("Handle the missing case")
        }
    }

    private var traits: UITraitCollection {
        UITraitCollection { mutableTraits in
            mutableTraits.forceTouchCapability = deviceType.deviceTraits.forceTouchCapability
            mutableTraits.layoutDirection = deviceType.deviceTraits.layoutDirection
            mutableTraits.userInterfaceIdiom = deviceType.deviceTraits.userInterfaceIdiom
            mutableTraits.horizontalSizeClass = deviceType.deviceTraits.horizontalSizeClass
            mutableTraits.verticalSizeClass = deviceType.deviceTraits.verticalSizeClass

            mutableTraits.userInterfaceStyle = appearance
            mutableTraits.preferredContentSizeCategory = .large
        }
        .modifyingTraits(extraTraits)
    }

    var snapshotDirectory: String {
        XCTestCase.snapshotsTestBaseUrl.appending(path: "__Snapshots__/\(testClassName)").path()
    }

    private var testClassName: String {
        URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingPathExtension()
            .lastPathComponent
    }
}
