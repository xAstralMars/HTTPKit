import Foundation

enum NetworkState {
    case loading
    case loaded(Data)
    case failure(Error)
}