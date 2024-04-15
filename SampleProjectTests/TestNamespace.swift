import Foundation

class TestNamespace {
    /// Returns the URL where the Test target source code is
    /// in relation to the location of this current file
    ///
    /// Used to specify the location of the snapshot references
    static func sourceCodeTestDirectory(file: StaticString = #file) -> URL {
        // For local snapshot tests, we need to find the test target directory
        // We find this through the location of this current file
        // which was the only way I found to do it
        URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingPathExtension()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
