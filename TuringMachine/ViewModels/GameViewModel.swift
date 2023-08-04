import SwiftUI

enum GameStatus {
    case waitingForOtherUsers
    case waitingForProblemSelection
    case problemSelecting
    case proposal
    case thumb
    case result
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

enum ResultType: String {
    case bothWrong = "BOTH_WRONG"
    case bothCorrect = "BOTH_CORRECT"
    case winner = "WINNER"
}

class GameViewModel: ObservableObject {
    @Published var status: GameStatus = .waitingForOtherUsers
    @Published var stage: Int = -1
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    @Published var problem: Problem?
    @Default(\.userId) var userId
    private var gameId: Int?
    private let webSocket = WebSocket()
    private let problemService = ProblemService()
    private let gameService = GameService()

    init() {
        start()
    }

    func webSocketHandler(result: Result<[String: Any], WebSocketError>) {
        switch result {
        case let .success(message):
            print(message)
            switch message["type"] as? String {
            case "STAGE":
                promoteStage()
            case "PROBLEM":
                moveToProblemSelection()
            case "PROBLEM_ID":
                if let problemId = message["problemId"] as? String {
                    fetchProblem(problemId)
                }
            case "Result":
                print("hrer")
//                if message[""]
            default:
                return
            }
        case .failure:
            showError(message: "Unable to establish a connection.")
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

    func fetchProblem(_ id: String) {
        problemService.getProblem(id: id) { result in
            switch result {
            case let .success(problem):
                self.problem = problem
            case .failure:
                self.showError(message: "Failed to download a problem")
            }
        }
    }

    private func promoteStage() {
        stage += 1
        if stage == 0 {
            status = .waitingForProblemSelection
        } else {
            status = .proposal
        }
    }

    private func moveToProblemSelection() {
        status = .problemSelecting
    }

    func showError(message: String) {
        isError = true
        errorMessage = message
    }

    func quit(completion: @escaping () -> Void) {
        completion()
    }
}
