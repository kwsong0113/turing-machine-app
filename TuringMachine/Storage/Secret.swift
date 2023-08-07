import Foundation

struct Secret {
    static var webSocketEndpointURL: String {
        getValue(forKey: "WEBSOCKET_ENDPOINT_URL")
    }

    static var apiEndpointURL: String {
        getValue(forKey: "API_ENDPOINT_URL")
    }

    private static func getValue(forKey key: String) -> String {
        guard let plistPath = Bundle.main.path(forResource: "Secret", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: plistPath)
        guard let value = plist?.object(forKey: key) as? String else { return "" }
        return value
    }
}
