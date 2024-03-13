import UIKit
import SnapshotTesting

/// A way to encapsule the device where snapshots are taken on
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
