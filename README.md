# Red Paprika Recipes App
Welcome to Red Paprika, a super simple app that collects recipes around the  world.

## Summary
Red Paprika is a simple MVP of a recipe app, built with SwiftUI, SwiftData and simplicity in mind.
### main features
- Access a list of recipes from around the world, sorted by cuisine type.
    - you can scroll vertically through cuisines, and horizontally through recipes of a specific cuisine
- Tap on a recipe card to view the web page of the recipe itself, to learn more about ingredients and any other detail
- Tap on the **watch** button on the bottom-right of each recipe card to watch a YouTube video of the recipe
- Pull-to-refresh to refresh the recipe list at any time
- The app handles situations like errors from the backend: to simulate this, you can build this project from Xcode and in the file `RecipeService.swift` change the designated endpoint to see how the app handles these states.

<div align="center">
<video src="https://github.com/user-attachments/assets/f339a7d6-b37f-4c63-9413-50fd1892364c" width="400">
</div>

## Focus Areas
The main areas of focus are the following. All of them reflect the spirit of this project, which is to build it with efficiency in mind by using the latest technologies:
- Concurrency: the entire project is built with Swift modern concurrency in mind, particularly complete strict concurrency is enabled on all targets
- Modularity: the architecture is a lightweight MVVM, meaning that where appropriate (that is where we need to hold a state), views have viewModels, otherwise it falls back to some sort of MV (model-view). This plays particularly well with SwiftData
- SwiftData: the new framework to store data locally in Swift (it's still backed by Core Data, but more friendly maybe? 😀)
- Swift Testing: the new testing framework in Swift that makes tests more readable and expressive

## Time Spent
probably something between 16 to 20 hrs. A few nights and some work through a weekend.

## Trade-offs and Decisions
I wanted to add more features, but for the sake of time-boxing, I decided that these can be for a ***future release***. Particularly:
- Search and filter(s): a search bar at the top and one or more filters (e.g.)
- A favorite/unfavorite button (goes well with the aforementioned filters)
- More appealing error and empty views, as well as progress views
- a ***debug*** menu that for example lets you choose the endpoint without the need of using Xcode and restarting the app to change it
- even more testing
- A more sophisticated way to render (and possibly scale) the images

## Weakest Part of the Project
- The fetch logic is pretty simple, works well with a compact amount of data, but will need tweaking to treat large amounts (possibly paginated)
- Network calls are one shot and do not have retry logic nor queues: in case of an app with multiple call that can take long, these should be considered
- Not a weakness per se, but needs to be mentioned: SwiftData would show some errors in the console like `error: the replacement path doesn't exist:[]`. These do not cause crash, and investigating around (for example [here](https://forums.developer.apple.com/forums/thread/762669)), seems that this is a common issue that Apple is aware of, but should not prevent the app from working.

## Additional information
In this project, I've used some free icons from the web that require attribution. Here they are:

the app icon used for this project is provided by [Paprika icons created by Sophia tkx - Flaticon](https://www.flaticon.com/free-icons/paprika)

the youtube icon used for this project is provided by [Youtube icons created by IconBaandar - Flaticon](https://www.flaticon.com/free-icons/youtube)

the placeholder image used for this projectis provided by [Recipe icons created by Edwinp99 - Flaticon](https://www.flaticon.com/free-icons/recipe)

the rounded flag icons used in this project are provided by the following creators:

[United states icons created by Freepik - Flaticon](https://www.flaticon.com/free-icons/united-states)

[European icons created by amoghdesign - Flaticon](https://www.flaticon.com/free-icons/european)

[Canada icons created by GeekClick - Flaticon](https://www.flaticon.com/free-icons/canada)

[Croatian icons created by amoghdesign - Flaticon](https://www.flaticon.com/free-icons/croatian)

[France icons created by Freepik - Flaticon](https://www.flaticon.com/free-icons/france)

[Greece icons created by Marcus Christensen - Flaticon](https://www.flaticon.com/free-icons/greece)

[Italy icons created by Freepik - Flaticon](https://www.flaticon.com/free-icons/italy)

[Malaysia icons created by amoghdesign - Flaticon](https://www.flaticon.com/free-icons/malaysia)

[Poland icons created by GeekClick - Flaticon](https://www.flaticon.com/free-icons/poland)

[Portugal icons created by iconset.co - Flaticon](https://www.flaticon.com/free-icons/portugal)

[Russia icons created by GeekClick - Flaticon](https://www.flaticon.com/free-icons/russia)

[Tunisia icons created by amoghdesign - Flaticon](https://www.flaticon.com/free-icons/tunisia)
