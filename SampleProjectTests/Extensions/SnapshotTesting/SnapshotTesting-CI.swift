import Foundation
import SnapshotTesting
import XCTest

extension XCTestCase {
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

        let snapshotDirectory = TestNamespace.sourceCodeTestDirectory()
            .appending(path: "__Snapshots__/\(testClassName)")
            .path()

        let failure = verifySnapshot(
            of: try value(),
            as: snapshotting,
            named: name,
            record: recording,
//            snapshotDirectory: String?,
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
