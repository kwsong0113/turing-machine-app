import Foundation

class WebSocket: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask? {
        didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
    }

    init() {}

    func connect(
        url: String,
        completionHandler: @escaping (Result<[String: Any], WebSocketError>) -> Void
    ) {
        guard let fullUrl = URL(string:
            (ProcessInfo.processInfo.environment["WEBSOCKET_ENDPOINT_URL"] ?? "")
                + url
        ) else { return }
        let request = URLRequest(url: fullUrl)
        print(fullUrl)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receive(completionHandler)
    }

    func close() {
        webSocketTask = nil
    }

    func receive(_ completionHandler: @escaping (Result<[String: Any], WebSocketError>) -> Void) {
        webSocketTask?.receive { result in
            switch result {
            case let .success(message):
                switch message {
                case let .string(text):
                    guard let data = text.data(using: .utf8) else { return }
                    guard let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                    completionHandler(.success(object))
                case .data:
                    completionHandler(.failure(WebSocketError.dataError))
                @unknown default:
                    completionHandler(.failure(WebSocketError.unknownError))
                }
            case .failure:
                completionHandler(.failure(WebSocketError.transportError))
            }
            self.receive(completionHandler)
        }
    }

    func send(_ message: Encodable) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(message) else { return }
        guard let messageString = String(data: data, encoding: .utf8) else { return }
        webSocketTask?.send(.string(messageString)) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
