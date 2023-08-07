import Foundation
protocol Serviceable {
    var url: String { get }
    var networkManager: NetworkManger { get }
}

extension Serviceable {
    var baseUrl: String { Secret.apiEndpointURL + url }
}
