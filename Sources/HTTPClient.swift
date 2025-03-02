import Foundation

public struct NetworkClient {
    public static let shared: NetworkClient = NetworkClient()

    private init() {}

    public func request<T: Decodable>(_ networkCall: NetworkCall) async throws -> T {
        guard networkCall.url != nil else { throw NSError(domain: "com.httpkit.invalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]) }
        
        var request = URLRequest(url: networkCall.url!)
        request.httpMethod = networkCall.method.asString
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let headers = networkCall.headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let timeout = networkCall.timeout {
            request.timeoutInterval = timeout
        }

        if let body = networkCall.body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        return try await makeRequest(request, retry: networkCall.retry ?? false)
    }

    private func makeRequest<T: Decodable>(_ request: URLRequest, retry: Bool, maxRetries: Int = 3) async throws -> T {
        var attempts = 0
        var lastError: Error?

        while attempts < (retry ? maxRetries : 1) {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    let error = NSError(domain: "com.httpkit.invalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    throw error
                }
                
                //                do {
                let formatter = ISO8601DateFormatter()
                // Include fractional seconds in the format options.
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
                let decodedResponse: T = try jsonDecoder.decode(T.self, from: data)
                return decodedResponse
                //                } catch {
                //                    print(String(describing: error))
                //                }
            } catch {
                lastError = error
                attempts += 1
                
                print(String(describing: error))
            }
        }

        throw lastError ?? NSError(domain: "com.httpkit.requestFailed", code: -1, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
    }
}
