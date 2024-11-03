import SwiftUI

struct NetworkView<Content: View, LoadingView: View, FailureView: View>: View {
    @State private var networkState: NetworkState = .loading

    private let networkCall: NetworkCall
    private let content: (Data) -> Content
    private let loading: () -> LoadingView
    private let failure: (Error) -> FailureView

    init(networkCall: NetworkCall,
         @ViewBuilder content: @escaping (Data) -> Content,
         @ViewBuilder loading: @escaping () -> LoadingView,
         @ViewBuilder failure: @escaping (Error) -> FailureView) {
        self.networkCall = networkCall
        self.content = content
        self.loading = loading
        self.failure = failure
    }

    var body: some View {
        VStack {
            switch networkState {
            case .loading:
                loading()
            case .loaded(let data):
                content(data)
            case .failure(let error):
                failure(error)
            }
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        networkState = .loading
        Task {
            do {
                let data: Data = try await NetworkClient.shared.request(networkCall)
                networkState = .loaded(data)
            } catch {
                networkState = .failure(error)
            }
        }
    }
}

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

#Preview {
    MockNetworkView()
}
