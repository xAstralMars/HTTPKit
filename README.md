<h1 align="center">
  HTTPKit
</h1>
<p align="center">
  HTTPKit is a highly versatile toolkit for managing all sorts of HTTP requests directly within SwiftUI or UIKit.
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

HTTPUI makes it easier to integrate with SwiftUI. With `NetworkView`, you can show views with 3 states: loaded, error, and loading, with a simple closure syntax. Here's an example with a GET request:

<!-- TODO: Figure out HTTPUI logistics -->

```swift
NetworkView("GET", url: URL("https://example.com/foo")) { result in
  Text("Successfully sent a GET request")
} loading: {
  ProgressView()
} error: {
  Text("Error")
}
```

## 📝 License

This project is licensed under the **MIT license**.

See [LICENSE](https://github.com/xastralmars/HTTPKit) for more information.
