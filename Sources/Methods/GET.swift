import Foundation

func sendGetRequest<U: Decodable>(url: URL) async throws -> U {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
        let error = NSError(domain: "com.httpkit.invalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        throw error
    }

    let decodedResponse: U = try JSONDecoder().decode(U.self, from: data)
    return decodedResponse
}