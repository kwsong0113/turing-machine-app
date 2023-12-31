import BottomSheetSwiftUI
import Foundation

enum GameStatus {
    case waitingForOtherUsers
    case waitingForProblemSelection
    case problemSelecting
    case proposal
    case proposalResult
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

enum GameResultType: String {
    case bothWrong = "BOTH_WRONG"
    case bothCorrect = "BOTH_CORRECT"
    case winner = "WINNER"
}

enum VerificationResultType {
    case correct
    case wrong
    case skip
}

enum Tab: CaseIterable, Identifiable {
    case criteria
    case verification

    var id: Self {
        self
    }
}

class GameViewModel: ObservableObject {
    @Published var status: GameStatus = .waitingForOtherUsers
    @Published var stage: Int = -1
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    @Published var problem: Problem?
    @Published var verificationRecord: [[VerificationResultType]] = []
    @Published var proposalRecord: [Int] = []
    @Published var result: GameResultType = .bothWrong
    @Published var isUserWinner: Bool = false
    @Published var bottomSheetPosition: BottomSheetPosition = .hidden
    @Published var selectedTab: Tab = .criteria
    @Default(\.userId) var userId
    private var gameId: Int?
    private var webSocket = WebSocket()
    private let problemService = ProblemService()
    private let gameService = GameService()

    init() {
        start()
    }

    internal init(
        status: GameStatus = .waitingForOtherUsers,
        stage: Int = -1,
        isError: Bool = false,
        errorMessage: String? = nil,
        problem: Problem? = nil,
        verificationRecord: [[VerificationResultType]] = [],
        proposalRecord: [Int] = [],
        result: GameResultType = .bothWrong,
        isUserWinner: Bool = false,
        bottomSheetPosition: BottomSheetPosition = .hidden,
        selectedTab: Tab = .criteria,
        userId _: Int? = nil,
        gameId: Int? = nil,
        webSocket: WebSocket = WebSocket()
    ) {
        self.status = status
        self.stage = stage
        self.isError = isError
        self.errorMessage = errorMessage
        self.problem = problem
        self.verificationRecord = verificationRecord
        self.proposalRecord = proposalRecord
        self.result = result
        self.isUserWinner = isUserWinner
        self.bottomSheetPosition = bottomSheetPosition
        self.selectedTab = selectedTab
        self.gameId = gameId
        self.webSocket = webSocket
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
                if let problemId = message["id"] as? String {
                    fetchProblem(problemId)
                }
            case "RESULT":
                guard let type = message["result_type"] as? String else { return }
                if type == "NO_THUMB" { return }
                showResult(type: type, winnerId: message["winner_id"] as? Int)
            default:
                return
            }
        case .failure:
            if status == .result { return }
            webSocket.close()
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
            case .failure:
                print("failure")
                self.showError(message: "Failed to start the game")
            }
        }
    }

    func fetchProblem(_ id: String) {
        problemService.getProblem(id: id) { result in
            switch result {
            case let .success(problem):
                self.problem = problem
                self.bottomSheetPosition = .dynamicTop
            case .failure:
                self.showError(message: "Failed to download a problem")
            }
        }
    }

    func askQuestion(proposal: Int, verifierIndices: [Int]) {
        guard let problem else { return }
        status = .proposalResult
        problemService.verify(problemId: problem.id, proposal: proposal, verifierIndices: verifierIndices) { result in
            switch result {
            case let .success(successResult):
                var verificationResult: [VerificationResultType] = Array(
                    repeating: .skip,
                    count: problem.verifiers.count
                )
                for (idx, val) in successResult.enumerated() {
                    verificationResult[verifierIndices[idx]] = val ? .correct : .wrong
                }
                self.verificationRecord.append(verificationResult)
                self.proposalRecord.append(proposal)
            case .failure:
                self.showError(message: "Failed to verify the proposal")
            }
        }
    }

    func moveToThumb() {
        status = .thumb
    }

    private func promoteStage() {
        DispatchQueue.main.async {
            self.stage += 1
            if self.stage == 0 {
                self.status = .waitingForProblemSelection
            } else {
                self.status = .proposal
            }
        }
    }

    private func moveToProblemSelection() {
        DispatchQueue.main.async {
            self.status = .problemSelecting
        }
    }

    func showResult(type: String, winnerId: Int?) {
        DispatchQueue.main.async {
            self.status = .result
            switch type {
            case "BOTH_CORRECT":
                self.result = .bothCorrect
            case "BOTH_WRONG":
                self.result = .bothWrong
            case "WINNER":
                self.result = .winner
                self.isUserWinner = winnerId == self.userId
            default:
                self.result = .bothWrong
            }
        }
    }

    func showError(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.status == .result { return }
            self.isError = true
            self.errorMessage = message
        }
    }

    func quit(completion: @escaping () -> Void) {
        reset()
        completion()
    }

    func reset() {
        DispatchQueue.main.async {
            self.status = .waitingForOtherUsers
            self.stage = -1
            self.isError = false
            self.errorMessage = nil
            self.problem = nil
            self.gameId = nil
            self.verificationRecord = [[]]
        }
        webSocket.close()
    }
}
