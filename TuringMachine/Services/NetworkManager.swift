import Alamofire

protocol NetworkMangerable {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: String]?,
        resultType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}

struct NetworkManger: NetworkMangerable {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        params: [String: String]?,
        resultType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let request = AF.request(
            path,
            method: method,
            parameters: params,
            encoder: JSONParameterEncoder.default
        )

        request.responseDecodable(of: resultType) { result in
            guard result.error == nil else {
                completion(.failure(APIError.transportError))
                return
            }

            guard let response = result.response, (200 ..< 300).contains(response.statusCode) else {
                completion(.failure(APIError.responseError))
                return
            }

            guard let data = result.value
            else {
                completion(.failure(APIError.dataError))
                return
            }

            completion(.success(data))
        }
    }
}
