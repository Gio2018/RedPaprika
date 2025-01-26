// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftUI
import SwiftData

/// A view that displays a carousel of cards and a title.
/// Used to display list or recipes for a specific cuisine.
struct CarouselView: View {
    let title: String
    @Query private var recipes: [Recipe]
    @State private var cards: [CardConfiguration] = []

    init(name: String) {
        self.title = name
        let predicate = #Predicate<Recipe> { $0.cuisine.name == name }
        let sortDescriptor = SortDescriptor<Recipe>(\.name, order: .forward)
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: [sortDescriptor])
        _recipes = Query(fetchDescriptor)
    }

    var body: some View {
        ZStack {
            makeBody()
                .padding(.top, 8)
        }
        .onChange(of: recipes, initial: true) {
            // Despite a little code overhead, this limits UI updates
            // to only when the recipes actually change.
            // The main reason for it being that queries could be
            // re-triggered when the carousel views go on and off screen.
            let newCards = updatedCards
            if newCards != cards {
                cards = newCards
            }
        }
    }
}

// MARK: view builders
private extension CarouselView {
    @ViewBuilder
    func makeBody() -> some View {
        if !cards.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(Color("highContrastInverted"))
                    .padding(.leading, 16)
                makeCarousel()
            }
        }
    }

    func makeCarousel() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 24) {
                ForEach(cards) {
                    CardView(carouselTitle: title, configuration: $0)
                        .padding(.vertical, 16)
                }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .leading) {
            Spacer()
                .frame(width: 8)
        }
        .safeAreaInset(edge: .trailing) {
            Spacer()
                .frame(width: 8)
        }
    }
}

// MARK: helpers
private extension CarouselView {
    /// Returns a swiftData agnostic list of recipes
    var updatedCards: [CardConfiguration] {
        recipes.map {
            CardConfiguration(
                id: $0.remoteID,
                name: $0.name,
                thumbnailUrl: $0.thumbnailUrl,
                photoUrl: $0.photoUrl,
                sourceUrl: $0.sourceUrl,
                youtubeUrl: $0.youtubeUrl
            )
        }
    }
}

#Preview {
    let container = PreviewProvider.previewContainer
    let dependencies = PreviewDependencies()
    let imageCache = PreviewImageCache()

    CarouselView(name: "Italian")
        .modelContainer(container)
        .environment(\.dependencies, dependencies)
        .environment(\.imageCache, imageCache)
}
