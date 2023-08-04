import Foundation

class WebSocket: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?

    init() {}

    func connect(
        url: String,
        completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void
    ) {
        guard let fullUrl = URL(string: "ws://"
            + (ProcessInfo.processInfo.environment["API_ENDPOINT_URL"] ?? "")
            + url
        ) else { return }
        print(fullUrl)
        let request = URLRequest(url: fullUrl)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        webSocketTask?.receive(completionHandler: completionHandler)
    }

    func send(_ message: Encodable) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(message) else { return }
        guard let messageString = String(data: data, encoding: .utf8) else { return }
        print(messageString)
//        webSocketTask?.send(.string(messageString)) { error in
//            if let error {
//                print(error.localizedDescription)
//            }
//        }
    }
}
