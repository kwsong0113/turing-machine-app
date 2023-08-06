import Foundation

struct VerifyRequest: Encodable {
    let proposal: Int
    let verifierIndices: [Int]
}

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

    func verify(
        problemId: String,
        proposal: Int, verifierIndices: [Int],
        completion: @escaping (Result<[Bool], APIError>) -> Void
    ) {
        networkManager.request(
            path: "\(baseUrl)/question/\(problemId)",
            method: .post,
            params: VerifyRequest(proposal: proposal, verifierIndices: verifierIndices),
            resultType: [Bool].self,
            completion: completion
        )
    }
}
