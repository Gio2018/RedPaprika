// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftData
import SwiftUI

struct CardView: View {
    let cuisineName: String
    let configuration: CardConfiguration

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @Query private var fetchedImage: [CachedImage]
    private var image: CachedImage? {
        fetchedImage.first
    }

    init(cuisineName: String, configuration: CardConfiguration) {
        self.cuisineName = cuisineName
        self.configuration = configuration
        let url = configuration.photoUrl ?? ""
        let predicate = #Predicate<CachedImage> { $0.url == url }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        _fetchedImage = Query(descriptor, animation: .smooth)
    }

    var body: some View {
        makeBody()
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: view builders
private extension CardView {
    /// Provides the width of a card depending on the horizontal size class.
    var cardWidth: CGFloat {
        let width = horizontalSizeClass == .regular ? Self.regularCardWidth : Self.compactCardWidth
        print(width)
        return width
    }

    func makeImage() -> some View {
        // TODO: replace with the downloaded or cached image
        Image("Placeholder")
            .resizable()
            .frame(width: cardWidth)
            .aspectRatio(1, contentMode: .fill)
            // .fixedSize(horizontal: false, vertical: true)
            .clipped()
            .padding(.bottom, 8)
    }

    func makeBottomContent() -> some View {
        VStack(alignment: .leading) {
            Text(configuration.name)
                .lineLimit(2)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.leading)
            Text(cuisineName)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
    }

    func makeBody() -> some View {
        VStack {
            makeImage()
            makeBottomContent()
        }
        .frame(width: cardWidth)
    }
}

// MARK: constants
private extension CardView {
    static let compactCardWidth: CGFloat = (UIScreen.main.bounds.width - 32) / 2
    static let regularCardWidth: CGFloat = (UIScreen.main.bounds.width - 48) / 3
}

#Preview {
    CardView(
        cuisineName: "Italian",
        configuration:
            CardConfiguration(
                id: UUID(),
                name: "Spaghetti Carbonara",
                thumbnailUrl: nil,
                photoUrl: "https://www.example.com/photo.jpg",
                sourceUrl: "https://www.example.com",
                youtubeUrl: nil


            )
    )
}
