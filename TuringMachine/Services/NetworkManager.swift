import Alamofire

protocol NetworkMangerable {
    func request<Response: Decodable, Parameters: Encodable>(
        path: String,
        method: HTTPMethod,
        params: Parameters?,
        resultType: Response.Type,
        completion: @escaping (Result<Response, APIError>) -> Void
    )
}

struct NetworkManger: NetworkMangerable {
    let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    let encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return JSONParameterEncoder(encoder: encoder)
    }()

    func request<Response: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        params: (some Encodable)? = nil,
        resultType: Response.Type,
        completion: @escaping (Result<Response, APIError>) -> Void
    ) {
        let request = AF.request(
            path,
            method: method,
            parameters: params,
            encoder: encoder
        )

        request.responseDecodable(of: resultType, decoder: decoder) { result in
            guard result.error == nil else {
                print(result.error)
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

    func request<T: Decodable>(
        path: String,
        resultType: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request<T>(path: path, resultType: resultType, completion: completion)
    }
}
