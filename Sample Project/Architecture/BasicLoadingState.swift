import Foundation

/// This is a way to genericly represent loading data in the system
/// and its possible states to avoid optional data
enum BasicLoadingState<DataType> {
    case idle
    case loading
    case dataLoaded(_ data: DataType)
    case error(_ error: Error)
}
