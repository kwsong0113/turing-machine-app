import Foundation

struct UserService: Serviceable {
    let url = "/users"
    let networkManager = NetworkManger()

    func createUser(username: String, completion: @escaping (Result<User, APIError>) -> Void) {
        networkManager.request(
            path: baseUrl,
            method: .post,
            params: ["username": username],
            resultType: User.self,
            completion: completion
        )
    }
}
