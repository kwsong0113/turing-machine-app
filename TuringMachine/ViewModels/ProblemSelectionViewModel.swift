import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy, standard, hard
    var id: Self {
        self
    }

    var value: Int {
        switch self {
        case .easy:
            return 0
        case .standard:
            return 1
        case .hard:
            return 2
        }
    }
}

class ProblemSelectionViewModel: ObservableObject {
    @Published var difficulty = Difficulty.easy
    @Published var numVerifiers = 4
}
