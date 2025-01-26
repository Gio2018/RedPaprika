// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

/// The state of a SwiftUI view with content that updates asynchronously
enum ViewState: Sendable {
    case idle
    case loading
    case ready
    case error
}
