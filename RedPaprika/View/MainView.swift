// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext

    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass

    @StateObject private var viewModel: MainViewModel

    @Query(sort: \Cuisine.name, order: .forward, animation: .smooth) private var cuisines: [Cuisine]

    init(_ viewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        makeScrollableContent()
                    }
                }
                .navigationTitle("Red Paprika Recipes")
                .scrollIndicators(.hidden)
                .background(Color("highContrast"))
                .environment(\.cardWidth, cardWidth(proxy.size))
            }
        }
        .refreshable {
            // A bit of a hack, but sometimes a task attached
            // to the ui could get cancelled if a redraw happens
            await Task(priority: .userInitiated) {
                await viewModel.fetchRecipes()
            }.value
        }
        .onAppear {
            Task(priority: .userInitiated) {
                await viewModel.fetchRecipes()
            }
        }
    }
}

// MARK: view builders
private extension MainView {
    @ViewBuilder
    func makeScrollableContent() -> some View {
        switch viewModel.state {
        case .loading:
            if cuisines.isEmpty {
                makeProgressView()
            } else {
                makeRecipeList()
            }
        case .error:
            makeErrorView()
        case .ready:
            if cuisines.isEmpty {
                makeEmptyResultsView()
            } else {
                makeRecipeList()
            }
        case .idle:
            makeProgressView()
        }
    }
    
    /// List of recipes to display
    func makeRecipeList() -> some View {
        ForEach(cuisines) { cuisine in
            CarouselView(name: cuisine.name)
        }
    }

    /// A centered progress view.
    func makeProgressView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }

    /// A view that informs users that no results were found
    func makeEmptyResultsView() -> some View {
        // TODO: replace this content with a more appealing view
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("No results found")
                Spacer()
            }
            Spacer()
        }
    }

    /// A view that informs users that an error occurred
    func makeErrorView() -> some View {
        // TODO: replace this content with a more appealing view
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("An error occurred")
                Spacer()
            }
            Spacer()
        }
    }

    enum LayoutWidth {
        case compact // iPhone portrait and iPad split view compact
        case wide // iPad portrait
        case extraWide // iPad landscape
    }

    /// Determine the size of the current layout
    func layoutWidth(_ screenSize: CGSize) -> LayoutWidth {
        guard horizontalSizeClass == .regular && UIDevice.current.userInterfaceIdiom == .pad else {
            return .compact
        }
        return screenSize.width > screenSize.height ? .extraWide : .wide
    }

    /// Calculate carousel cell width based on which layout is being used
    /// Allows card sizes to adapt to rotation and split view on iPad
    func cardWidth(_ screenSize: CGSize) -> CGFloat {
        switch layoutWidth(screenSize) {
        case .compact:
            return screenSize.width * 0.54
        case .wide:
            return screenSize.width * 0.34
        case .extraWide:
            return screenSize.width * 0.24
        }
    }
}

#Preview {
    let container = PreviewProvider.previewContainer
    let dependencies = PreviewDependencies()
    let imageCache = PreviewImageCache()
    MainView(MainViewModel(store: PreviewStore(), service: PreviewRecipeService()))
        .modelContainer(container)
        .environment(\.dependencies, dependencies)
        .environment(\.imageCache, imageCache)
}
