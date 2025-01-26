// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftData
import SwiftUI

/// A view that displays a card with an image and some text.
/// Used to display the content of a recipe.
struct CardView: View {
    let carouselTitle: String
    let configuration: CardConfiguration

    @Environment(\.cardWidth)
    private var cardlWidth

    @Environment(\.imageCache)
    private var imageCache

    @Environment(\.dependencies)
    private var dependencies

    @State private var isPresentingSourcePage: Bool = false
    @State private var isPresentingYoutubeVideo: Bool = false

    @Query private var fetchedImage: [CachedImage]
    private var image: CachedImage? {
        fetchedImage.first
    }

    init(carouselTitle: String, configuration: CardConfiguration) {
        self.carouselTitle = carouselTitle
        self.configuration = configuration
        let url = configuration.photoUrl ?? ""
        let predicate = #Predicate<CachedImage> { $0.url == url }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        _fetchedImage = Query(descriptor, animation: .smooth)
    }

    var body: some View {
        makeBody()
            // ensure taps are effective on the whole card.
            .contentShape(Rectangle())
            .fullScreenCover(isPresented: $isPresentingSourcePage) {
                SafariView(url: URL(string: configuration.sourceUrl!)!)
                    .ignoresSafeArea(.all)
            }
            .fullScreenCover(isPresented: $isPresentingYoutubeVideo) {
                SafariView(url: URL(string: configuration.youtubeUrl!)!)
                    .ignoresSafeArea(.all)
            }
            .onTapGesture {
                // these checks ensure that the above force unwraps are safe.
                if let urlString = configuration.sourceUrl,
                    let _ = URL(string: urlString) {
                    isPresentingSourcePage = true
                }
            }
    }
}

// MARK: view builders
private extension CardView {
    func makeImage() -> some View {
        // TODO: replace with the downloaded or cached image
        ZStack(alignment: .topLeading) {
            RemoteImage(
                url: configuration.photoUrl ?? "",
                service: dependencies.makeImageService(),
                cache: imageCache
            )
            .frame(width: cardlWidth)
            // scaling like this is pretty basic and sligfhtly deformes the image
            // an improvement would require a more sophisticated resizing of the image
            // or receiving them resized from the api.
            .aspectRatio(1.1, contentMode: .fit)
            .fixedSize(horizontal: false, vertical: true)
            .clipped()
            .padding(.bottom, 8)
            Image(carouselTitle)
                .resizable()
                .frame(width: 24, height: 24)
                .opacity(0.6)
                .padding()
        }
    }

    func makeBottomContent() -> some View {
        VStack(alignment: .leading) {
            Text(configuration.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color("highContrastInverted"))
                .padding(.leading, 16)
                .padding(.trailing, 16)
            Spacer()
            HStack {
                Spacer()
                Button {
                    // these checks ensure that the above force unwraps are safe.
                    if let urlString = configuration.youtubeUrl,
                        let _ = URL(string: urlString) {
                        isPresentingYoutubeVideo = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "play.rectangle")
                            .resizable()
                            .foregroundColor(Color("darkRed"))
                            .frame(width: 30, height: 20)
                        Text("Watch")
                            .foregroundColor(Color("secondaryText"))
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .frame(width: cardlWidth)
    }

    func makeBody() -> some View {
        VStack {
            makeImage()
            makeBottomContent()
        }
        .background(Color("cardBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: cardlWidth, height: cardlWidth + 88)
        .shadow(color: Color("cardShadow"), radius: 6, x: 0, y: 0)
    }
}

#Preview {
    let container = PreviewProvider.previewContainer
    let dependencies = PreviewDependencies()
    let imageCache = PreviewImageCache()

    CardView(
        carouselTitle: "Italian",
        configuration:
            CardConfiguration(
                id: UUID(),
                name: "Spaghetti Carbonara",
                thumbnailUrl: nil,
                photoUrl: "https://via.placeholder.com/150",
                sourceUrl: "https://www.example.com",
                youtubeUrl: nil
            )
    )
    .modelContainer(container)
    .environment(\.dependencies, dependencies)
    .environment(\.imageCache, imageCache)
}
