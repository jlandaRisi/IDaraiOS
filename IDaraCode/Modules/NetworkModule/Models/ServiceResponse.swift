enum ServiceResponse<T: Decodable> {
    case success(T)
    case failed(ServiceResponseError)
}
