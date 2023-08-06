import Foundation

class QuestionViewModel: ObservableObject {
    @Published var digits: [Int] = [2, 2, 2]
    @Published var isVerifiersOn = [Bool](repeating: false, count: 6)

    var proposal: Int { digits[0] * 100 + digits[1] * 10 + digits[2] + 111 }
    var verifierIndices: [Int] {
        isVerifiersOn.enumerated().filter(\.element).map(\.offset)
    }
}
