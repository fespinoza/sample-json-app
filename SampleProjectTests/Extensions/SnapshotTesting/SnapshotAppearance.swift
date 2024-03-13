import UIKit

enum SnapshotAppearance: String, CustomStringConvertible {
    case lightMode = "Light"
    case darkMode = "Dark"

    var description: String { rawValue }

    var traits: UITraitCollection {
        switch self {
        case .lightMode: .lightMode
        case .darkMode: .darkMode
        }
    }
}
