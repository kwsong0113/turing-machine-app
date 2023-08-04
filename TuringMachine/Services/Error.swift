enum APIError: Error {
    case transportError
    case responseError
    case dataError
}

enum WebSocketError: Error {
    case unknownError
    case transportError
    case dataError
}
