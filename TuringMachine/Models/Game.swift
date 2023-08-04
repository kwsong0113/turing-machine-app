import Foundation

enum ProblemStatus: String, Codable {
    case waiting = "WAITING"
    case playing = "PLAYING"
    case ended = "ENDED"
}

struct Game: Codable, Identifiable {
    let id: Int
    let status: ProblemStatus
    let problemId: String?
}
