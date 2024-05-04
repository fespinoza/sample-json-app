import Foundation
import UIKit
import SnapshotTesting

extension Snapshotting where Value == UIViewController, Format == UIImage {

    public static func customImage(
        on config: ViewImageConfig,
        precision: Float = 0.98,
        perceptualPrecision: Float = 0.98,
        size: CGSize? = nil,
        traits: UITraitCollection = UITraitCollection(userInterfaceStyle: .light)
    ) -> Snapshotting {
        .image(
            on: config,
            precision: precision,
            perceptualPrecision: perceptualPrecision,
            size: size,
            traits: traits
        )
    }
}
