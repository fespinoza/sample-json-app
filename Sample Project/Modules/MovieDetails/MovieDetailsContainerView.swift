enum BasicLoadingState<DataType> {
    case idle
    case loading
    case dataLoaded(_ data: DataType)
    case error(_ error: Error)
}

