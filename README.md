# Recipes App

A cross-platform Flutter application for browsing, filtering, and favoriting recipes. The app fetches recipes from the Spoonacular API and supports Android, iOS, Web, Windows, macOS, and Linux.

## Features

- Browse random recipes and by category
- View detailed recipe information (ingredients, steps, etc.)
- Mark recipes as favorites
- Filter recipes by dietary preferences (gluten-free, lactose-free, vegan, vegetarian)
- Responsive and modern UI
- Cross-platform support

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (usually included with Flutter)
- An API key from [Spoonacular](https://spoonacular.com/food-api) (already included in the code for demo purposes)

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/recipes.git
    cd recipes
    ```

2. Install dependencies:
    ```sh
    flutter pub get
    ```

3. Run the app:
    - For mobile:
        ```sh
        flutter run
        ```
    - For web:
        ```sh
        flutter run -d chrome
        ```
    - For desktop (Windows/macOS/Linux):
        ```sh
        flutter run -d windows   # or macos/linux
        ```

## Project Structure

- [lib](http://_vscodecontentref_/1)
  - [main.dart](http://_vscodecontentref_/2) – App entry point
  - `screens/` – UI screens (categories, meals, filters, etc.)
  - `models/` – Data models (Meal, Category)
  - `providers/` – State management (Riverpod)
  - `services/` – API integration ([recipe_service.dart](http://_vscodecontentref_/3))
  - `widgets/` – Reusable UI components

## Configuration

- The Spoonacular API key is set in [recipe_service.dart](http://_vscodecontentref_/4).
- To use your own API key, replace the `_apiKey` value in that file.

## Dependencies

- [Flutter](https://flutter.dev/)
- [Riverpod](https://pub.dev/packages/flutter_riverpod)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [Transparent Image](https://pub.dev/packages/transparent_image)
- [HTTP](https://pub.dev/packages/http)

## License

This project is licensed under the MIT License.

---

**Note:** This app is for educational/demo purposes. For production use, secure your API keys and follow best practices for API usage.
