import Foundation

class RegisterViewModel: ObservableObject {
    @Published var username = ""

    func register(action: () -> Void) async {
        print(username)
        action()
    }
}
