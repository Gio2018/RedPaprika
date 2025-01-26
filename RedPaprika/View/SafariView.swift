// Red Paprika recipe app
// Giorgio Ruscigno, 2025.


import SwiftUI
import SafariServices

/// SwiftUI wrapper for `SFSafariViewController`
struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    let url: URL
    let readerMode: Bool

    init(url: URL, readerMode: Bool = false) {
        self.url = url
        self.readerMode = readerMode
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = readerMode
        let safariController = SFSafariViewController(url: url, configuration: config)
        return safariController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
