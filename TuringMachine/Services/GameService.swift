import Foundation

struct StartGameRequest: Encodable {
    let userId: Int?
}

struct GameService: Serviceable {
    let url = "/games"
    let networkManager = NetworkManger()
    @Default(\.userId) var userId

    func startGame(completion: @escaping (Result<Game, APIError>) -> Void) {
        networkManager.request(
            path: "\(baseUrl)/start",
            method: .post,
            params: StartGameRequest(userId: userId),
            resultType: Game.self,
            completion: completion
        )
    }
}
