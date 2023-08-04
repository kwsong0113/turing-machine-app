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
    @Default(\.userId) var userId
    private var gameId: Int?
    private let webSocket = WebSocket()
    private let problemService = ProblemService()
    private let gameService = GameService()

    init() {
        start()
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

    private func connectToWebSocket() {
        guard let gameId else { return }
        guard let userId else { return }
        webSocket.connect(url: "/games/ws/\(gameId)/\(userId)", completionHandler: webSocketHandler)
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

    func start() {
        gameService.startGame { result in
            switch result {
            case let .success(game):
                self.gameId = game.id
                self.connectToWebSocket()
            case let .failure(error):
                print(error)
                self.showError(message: "Failed to start the game")
            }
        }
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
