// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftUI

extension Image {
    /// Extract an image from data
    /// - Parameter data: the input `Data`
    /// - Returns: the rendered Image if data is not nil and valid
    static func fromData(_ data: Data?) -> Image? {
        guard let data, let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}
