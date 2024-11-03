import Foundation

func sendPostRequest<T: Encodable, U: Decodable>(url: URL, body: T) async throws -> U {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
        let error = NSError(domain: "com.example.network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        throw error
    }

    let decodedResponse: U = try JSONDecoder().decode(U.self, from: data)
    return decodedResponse
}