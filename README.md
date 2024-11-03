<h1 align="center">
  HTTPKit
</h1>
<p align="center">
  HTTPKit is a highly versatile toolkit for managing all sorts of HTTP requests directly within SwiftUI or UIKit. This package was designed to make network calls easier and to make them require less code.
</p>

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fclerk%2Fclerk-ios%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/clerk/clerk-ios)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fclerk%2Fclerk-ios%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/clerk/clerk-ios)

---

## 🧑‍💻 Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), navigate to your Xcode project, select `Package Dependencies` and click the `+` icon to search for `https://github.com/xAstralMars/HTTPKit`.

Alternatively, add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/xAstralMars/HTTPKit", from: "0.1.0")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate HTTPKit into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## 💻 Implementation

HTTPKit has a relatively simple syntax, supporting async/await, and errors are very easy to handle. You can easily decode responses using `Codable` syntax in Swift.

Here's how to send a GET request, using the `NetworkClient` object:

1. First, define your URL:

```swift
let getUrl = URL(string: "https://example.com/api/resource")!
```

2. Next, define your `Decodable` object, this makes it easier to convert JSON data into a Swift structure:

```swift
struct GetResponse: Decodable {
  let id: Int
  let message: String
}
```

3. Create your `NetworkCall` object instance, this defines the options for the final network request:

```swift
let networkCall = NetworkCall(
  method: .GET,
  body: nil,
  url: getUrl,
  headers: nil,
  retry: false,
  timeout: nil
)
```

4. Finally, send the network request:

```swift
Task {
  do {
      let response: GetResponse = try await NetworkClient.shared.request(networkCall)
      print("Success: \(response)")
  } catch {
      print("Error: \(error.localizedDescription)")
  }
}
```

---

HTTPKit also makes it easier to directly integrate with SwiftUI. With `NetworkView`, you can show views with 3 states: loaded, error, and loading, with a simple closure syntax. Here's an example with a GET request (without any coding/decoding):

```swift
var body: some View {
  let networkCall = NetworkCall(
      method: .GET,
      url: URL(string: "https://example.com/v1/resource")
  )

  NetworkView(networkCall: networkCall) { data in
      Text("Data loaded: \(String(describing: data))")
  } loading: {
      ProgressView("Loading...")
  } failure: { error in
      Text("Error: \(error.localizedDescription)")
  }
}
```

# 📚 API Reference

## NetworkClient

The `NetworkClient` struct provides a singleton-based client for handling network requests. It supports JSON-based HTTP requests with customizable headers, body, and timeout configurations. This client also has a retry mechanism for handling failed requests.

### Properties

| Property | Type            | Description                                                                          |
| -------- | --------------- | ------------------------------------------------------------------------------------ |
| `shared` | `NetworkClient` | The singleton instance of `NetworkClient` for shared access throughout your project. |

### Initializer

| Initializer      | Description                                     |
| ---------------- | ----------------------------------------------- |
| `private init()` | Private initializer to enforce singleton usage. |

### Methods

---

### `request`

Asynchronously executes a network call based on the provided configuration in `NetworkCall`.

```swift
public func request<T: Decodable>(_ networkCall: NetworkCall) async throws -> T
```

**Parameters:**

| Name          | Type          | Note                                                                                                                       |
| ------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `networkCall` | `NetworkCall` | Encapsulates details of the network request, including URL, HTTP method, headers, timeout, request body, and retry policy. |

**Throws:**

- `NSError` with domain `"com.httpkit.invalidURL"` and localized description "Invalid URL" if the provided URL is `nil`.
- Errors from `makeRequest` if there are issues during the request execution.

**Returns:**

- A decoded response of type `T`, where `T` conforms to `Decodable`.

---

### `makeRequest`

A private helper method to execute a `URLRequest` with retry functionality.

```swift
private func makeRequest<T: Decodable>(_ request: URLRequest, retry: Bool, maxRetries: Int = 3) async throws -> T
```

**Parameters:**

| Name         | Type                | Note                                                                   |
| ------------ | ------------------- | ---------------------------------------------------------------------- |
| `request`    | `URLRequest`        | The configured `URLRequest` instance.                                  |
| `retry`      | `Bool`              | Determines whether the request should be retried on failure.           |
| `maxRetries` | `Int` (default `3`) | The maximum number of retry attempts, applicable if `retry` is `true`. |

**Throws:**

- `NSError` with domain `"com.httpkit.invalidResponse"` if the response status code is not within the 200–299 range.
- The last error encountered during retries if all retry attempts fail.

**Returns:**

- A decoded response of type `T`, where `T` conforms to `Decodable`.

---

### Example Usage

```swift
let networkCall = NetworkCall(url: URL(string: "https://api.example.com/data"),
                              method: .get,
                              headers: ["Authorization": "Bearer token"],
                              timeout: 10,
                              retry: true)
do {
    let response: SomeDecodableType = try await NetworkClient.shared.request(networkCall)
    // Handle successful response
} catch {
    // Handle error
}
```

---

## NetworkView

The `NetworkView` struct is a generic SwiftUI view that handles different states of a network request, including loading, success, and failure. It uses a `NetworkCall` configuration to make requests and allows custom views for loading, content, and failure states.

### Properties

| Property       | Type                     | Description                                                                                         |
| -------------- | ------------------------ | --------------------------------------------------------------------------------------------------- |
| `networkState` | `NetworkState`           | The current state of the network request, initialized to `.loading`.                                |
| `networkCall`  | `NetworkCall`            | The network call configuration, containing URL, HTTP method, headers, and other request parameters. |
| `content`      | `(Data) -> Content`      | A view builder closure for rendering the view in the loaded state, receiving the loaded data.       |
| `loading`      | `() -> LoadingView`      | A view builder closure for rendering the view in the loading state.                                 |
| `failure`      | `(Error) -> FailureView` | A view builder closure for rendering the view in the failure state, receiving an error.             |

### Initializer

| Initializer                                                                                                                                             | Description                                                                                                        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `init(networkCall: NetworkCall, content: @escaping (Data) -> Content, loading: @escaping () -> LoadingView, failure: @escaping (Error) -> FailureView)` | Initializes the `NetworkView` with a `NetworkCall` and view builders for the loading, success, and failure states. |

### Methods

---

### `body`

Defines the main view body of `NetworkView`, which displays different views depending on the network state.

```swift
var body: some View
```

The body displays:

- **loading**: When `networkState` is `.loading`.
- **content**: When `networkState` is `.loaded`, using the provided data.
- **failure**: When `networkState` is `.failure`, using the provided error.

---

### `loadData`

Triggers a network request, updates the `networkState` to `.loading`, and handles success or failure.

```swift
private func loadData()
```

**Behavior:**

- Sets `networkState` to `.loading` initially.
- Asynchronously calls `NetworkClient.shared.request` with `networkCall` to fetch data.
- Updates `networkState` to `.loaded(data)` on success, or `.failure(error)` on failure.

---

### Example Usage

#### Basic Implementation

```swift
struct MockNetworkView: View {
    var body: some View {
        let networkCall = NetworkCall(
            method: .GET,
            url: URL(string: "https://example.com/v1/data")
        )

        NetworkView(networkCall: networkCall) { data in
            Text("Data loaded: \(String(describing: data))")
        } loading: {
            ProgressView("Loading...")
        } failure: { error in
            Text("Error: \(error.localizedDescription)")
        }
    }
}
```

#### Preview Example

```swift
#Preview {
    MockNetworkView()
}
```

---

## NetworkCall

The `NetworkCall` struct encapsulates the configuration required to make a network request, including HTTP method, URL, headers, request body, retry settings, and timeout interval.

### Properties

| Property  | Type                | Description                                                                                                  |
| --------- | ------------------- | ------------------------------------------------------------------------------------------------------------ |
| `method`  | `HTTPMethod`        | Specifies the HTTP method for the network request, such as GET or POST.                                      |
| `body`    | `Encodable?`        | The request body to be sent with the network call, which must conform to `Encodable`.                        |
| `url`     | `URL?`              | The URL to which the network request is made.                                                                |
| `headers` | `[String: String]?` | A dictionary of HTTP headers to include in the request, where each key-value pair represents a header field. |
| `retry`   | `Bool?`             | A Boolean that determines whether the request should retry upon failure. Default is `false`.                 |
| `timeout` | `TimeInterval?`     | The timeout interval for the request, measured in seconds.                                                   |

### Initializer

| Initializer                                                                                                                                                      | Description                                                                                                         |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `public init(method: HTTPMethod, body: Encodable? = nil, url: URL? = nil, headers: [String: String]? = nil, retry: Bool? = false, timeout: TimeInterval? = nil)` | Initializes a `NetworkCall` with the specified HTTP method, body, URL, headers, retry option, and timeout interval. |

### Example Usage

```swift
let networkCall = NetworkCall(
    method: .POST,
    body: MyEncodableBody(data: "example"),
    url: URL(string: "https://api.example.com/data"),
    headers: ["Authorization": "Bearer token"],
    retry: true,
    timeout: 30
)
```

## 📝 License

This project is licensed under the **MIT license**.

See [LICENSE](https://github.com/xastralmars/HTTPKit?tab=MIT-1-ov-file) for more information.
