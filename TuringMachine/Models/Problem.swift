import Foundation

struct Problem: Codable, Identifiable {
    let id: String
    let verifiers: [Int]
    let laws: [Int]
    let code: Int
}
