import Foundation

extension Int {
    func toAlphabet() -> String {
        guard let unicodeScalar = UnicodeScalar(97 + self) else { return "A" }
        return String(unicodeScalar).uppercased()
    }
}
