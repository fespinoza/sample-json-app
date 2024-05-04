import Foundation
import SnapshotTesting
import XCTest

extension XCTestCase {
    var isRunningOnCI: Bool {
        ProcessInfo.processInfo.environment["CI"]?.lowercased() == "true"
    }

    /// Returns the URL where the bundle is present
    ///
    /// Used to specify the location of the snapshot references on CI
    private var testBundleUrl: URL {
        guard let url = Bundle(for: TestNamespace.self).resourceURL else {
            fatalError("❌ we couldn't access to the test bundle URL")
        }
        return url
    }

    public func customAssertSnapshot<Value, Format>(
        of value: @autoclosure () throws -> Value,
        as snapshotting: Snapshotting<Value, Format>,
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let testClassName = URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingPathExtension()
            .lastPathComponent

        let baseDirectory = isRunningOnCI ? testBundleUrl : TestNamespace.sourceCodeTestDirectory()

        let snapshotDirectory = baseDirectory.appending(path: "__Snapshots__/\(testClassName)").path()

        let failure = verifySnapshot(
            of: try value(),
            as: snapshotting,
            named: name,
            record: recording,
            snapshotDirectory: snapshotDirectory,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
        guard let message = failure else { return }
        XCTFail(message, file: file, line: line)
    }
}
