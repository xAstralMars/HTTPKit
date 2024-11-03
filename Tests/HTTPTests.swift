import XCTest
@testable import HTTPKit

final class HTTPTests: XCTestCase {
    func testRequestError() throws {
        struct GetResponse: Decodable {
            let id: Int
            let message: String
        }
        
        let getUrl = URL(string: "https://example.com/api/resource")!
        
        let networkCall = NetworkCall(
            method: .GET,
            body: nil,
            url: getUrl,
            headers: nil,
            retry: false,
            timeout: nil
        )
        
        Task {
            do {
                let response: GetResponse = try await NetworkClient.shared.request(networkCall)
                print("Success: \(response)")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
