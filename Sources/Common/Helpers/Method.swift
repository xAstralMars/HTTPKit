import Foundation

public enum HTTPMethod {
    case GET
    case POST
    case PUT
    case DELETE

    var asString: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PUT:
            return "PUT"
        case .DELETE:
            return "DELETE"
        }
    }
}