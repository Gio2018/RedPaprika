// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftUI
import SwiftData

struct CarouselView: View {
    let cuisineName: String
    @Query private var recipes: [Recipe]
    @State private var cards: [CardConfiguration] = []

    init(name: String) {
        self.cuisineName = name
        let predicate = #Predicate<Recipe> { $0.cuisine.name == name }
        let sortDescriptor = SortDescriptor<Recipe>(\.name, order: .forward)
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: [sortDescriptor])
        _recipes = Query(fetchDescriptor)
    }

    var body: some View {
        ZStack {
            makeBody()
        }
        .onChange(of: recipes, initial: true) {
            // Despite a little code overhead, this limits UI updates
            // to only when the recipes actually change.
            // The main reason for it being that queries could be
            // re-triggered when the carousel views go on and off screen.
            if updatedCards != cards {
                cards = updatedCards
            }
        }
    }
}

// MARK: view builders
private extension CarouselView {
    @ViewBuilder
    func makeBody() -> some View {
        if !cards.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text(cuisineName)
                makeCarousel()
            }
            .background(Color.yellow)
        }
    }

    func makeCarousel() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(cards) {
                    RecipeCard(cuisineName: cuisineName, configuration: $0)
                        .padding(.vertical, 16)
                }
            }
            .background(Color.red)
        }
        .background(Color.green)
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

    CarouselView(name: "Italian")
        .modelContainer(container)
}
