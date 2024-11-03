import Foundation

public struct NetworkCall {
    let method: HTTPMethod
    let body: Encodable?
    let url: URL?
    let headers: [String: String]?
    let retry: Bool?
    let timeout: TimeInterval?
    
    public init(method: HTTPMethod, body: Encodable? = nil, url: URL? = nil, headers: [String: String]? = nil, retry: Bool? = false, timeout: TimeInterval? = nil) {
        self.method = method
        self.body = body
        self.url = url
        self.headers = headers
        self.retry = retry
        self.timeout = timeout
    }
}
