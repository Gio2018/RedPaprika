// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData
import SwiftUI

@Model final class CachedImage {
    var url: String
    var data: Data

    init(url: String, data: Data) {
        self.url = url
        self.data = data
    }
}

extension CachedImage {
    /// SwiftUI `Image` from stored data
    var image: Image? {
        Image.fromData(data)
    }
}

