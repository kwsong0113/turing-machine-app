import SwiftUI

enum GameStatus {
    case waitingForOtherUsers
    case waitingForProblemSelection
    case problemSelecting
    case proposal
    case thumb
}

struct ProblemMessage: Encodable {
    let type: String = "PROBLEM"
    let difficulty: Int
    let numVerifiers: Int
}

enum ThumbDirection: String, Encodable {
    case thumbUp = "UP"
    case thumbDown = "DOWN"
}

struct ThumbMessage: Encodable {
    let type: String = "THUMB"
    let thumb: ThumbDirection
    var num: Int?
}

class GameViewModel: ObservableObject {
    @Published var status: GameStatus = .waitingForOtherUsers
    @Published var stage: Int = -1
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    private var gameId: Int?
    private var webSocket = WebSocket()
    init() {
        webSocket.connect(url: "/games/ws/1/2", completionHandler: webSocketHandler)
        self.sendThumbDownMessage()
    }

    func webSocketHandler(result: Result<URLSessionWebSocketTask.Message, Error>) {
        switch result {
        case .failure:
            //            print(error.localizedDescription)
            print("error")
        case let .success(message):
            switch message {
            case let .string(text):
                print("Text")
                print(text)
            case let .data(data):
                // Handle binary data
                print("Data")
                print(data)
            @unknown default:
                print("unknown")
            }
        }
    }

    func sendProblemMessage(difficulty: Int, numVerifiers: Int) {
        webSocket.send(ProblemMessage(difficulty: difficulty, numVerifiers: numVerifiers))
    }

    func sendThumbUpMessage(num: Int) {
        webSocket.send(ThumbMessage(thumb: .thumbUp, num: num))
    }

    func sendThumbDownMessage() {
        webSocket.send(ThumbMessage(thumb: .thumbDown))
    }

    func promoteStage() {
        stage += 1
        if stage == 0 {
            status = .waitingForProblemSelection
        } else {
            status = .proposal
        }
    }

    func showError(message: String) {
        isError = true
        errorMessage = message
    }

    func quit(completion: @escaping () -> Void) {
        completion()
    }
}
