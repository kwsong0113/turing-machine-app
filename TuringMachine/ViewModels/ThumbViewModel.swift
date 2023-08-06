import Foundation

class ThumbViewModel: ObservableObject {
    internal init(isThumbUp: Bool = true, digits: [Int] = [2, 2, 2], isDone: Bool = false) {
        self.isThumbUp = isThumbUp
        self.digits = digits
        self.isDone = isDone
    }

    @Published var isThumbUp: Bool = true
    @Published var digits: [Int] = [2, 2, 2]
    @Published var isDone: Bool = false
    var code: Int { digits[0] * 100 + digits[1] * 10 + digits[2] + 111 }
}
