import UIKit
import SnapshotTesting

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
