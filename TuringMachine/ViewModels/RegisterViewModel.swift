import Alamofire
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var isLoading = false
    @Published var isError = false
    @Default(\.username) var defaultUsername
    @Default(\.userId) var userId

    let userService = UserService()

    func register(action: @escaping () -> Void) {
        isLoading = true
        userService.createUser(username: username) { [self] result in
            isLoading = false
            switch result {
            case let .success(user):
                defaultUsername = user.username
                userId = user.id
                action()
            case .failure:
                isError = true
            }
        }
    }
}
