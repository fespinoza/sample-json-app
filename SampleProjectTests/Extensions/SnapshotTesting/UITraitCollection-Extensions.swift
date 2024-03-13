import UIKit
import SnapshotTesting

extension UITraitCollection {
    /// Convenience to get a dark mode trait collection
    static let darkMode = UITraitCollection(userInterfaceStyle: .dark)

    /// Convenience to get a light mode trait collection
    static let lightMode = UITraitCollection(userInterfaceStyle: .light)

    static func iPhone15Pro(_ orientation: ViewImageConfig.Orientation) -> UITraitCollection {
        .iPhone13(orientation)
    }
}
