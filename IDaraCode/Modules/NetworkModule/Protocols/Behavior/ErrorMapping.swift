protocol ErrorMapping {
    func map(statusCode: Int) -> ErrorNetworkType?
}
