import Foundation

struct ProblemService: Serviceable {
    let url = "/problems"
    let networkManager = NetworkManger()

    func getProblem(id: String, completion: @escaping (Result<Problem, APIError>) -> Void) {
        networkManager.request(
            path: "\(baseUrl)/\(id)",
            resultType: Problem.self,
            completion: completion
        )
    }
}
