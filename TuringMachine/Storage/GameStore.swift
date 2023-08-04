import Foundation

enum GameStatus {
    case idle
    case waitingForOtherUsers
    case waitingForProblemSelection
    case problemSelecting
    case proposal
    case thumb
    case error
}

class GameStore: ObservableObject {
    @Published var status: GameStatus = .idle {
        didSet {
            isPlaying = status != .idle
        }
    }

    @Published var stage: Int = -1

    @Published var isPlaying: Bool = false

    func start() {
        status = .waitingForOtherUsers
        // connect to websocket
    }

    func promoteStage() {
        stage += 1
        if stage == 0 {
            status = .waitingForProblemSelection
        } else {
            status = .proposal
        }
    }
}
