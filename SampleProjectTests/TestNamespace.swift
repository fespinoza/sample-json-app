import Foundation

class TestNamespace {
}

extension Bundle {
    static var test: Bundle { Bundle(for: TestNamespace.self) }
}
