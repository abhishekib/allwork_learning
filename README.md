# Flutter Dynamic Content App

This Flutter app displays a structured and interactive interface with content fetched dynamically from APIs. The app follows a layered architecture with clear separation of concerns, using `providers` for data fetching, `controllers` for state management, `models` for defining data structures, and `views` for UI components.

## Features

- **Dynamic Main Menu**: Fetches a list of menu items from an API (e.g., "Daily Dua", "Surah") and displays them on the home screen.
- **Category View**: Displays a list of categories for each menu item when clicked.
- **Category Item View**: Shows individual titles in each category with an option to view lyrics and listen to audio.
- **Lyrics & Audio View**: Plays audio synchronized with lyrics (in Arabic, Transliteration, and Translation) in a tabbed view.

## Architecture Overview

The app follows a layered architecture:

- **Controllers**: Handle the logic and state management of the app, interacting with providers.
- **Models**: Define the structure of the data fetched from APIs.
- **Providers**: Manage API calls and provide data to controllers.
- **Views**: UI components of the app.

## Folder Structure

```
   lib/
   │
   ├── controllers/                # Manages app state and logic
   │   ├── menu_list_controller.dart
   │   ├── category_controller.dart
   │
   ├── models/                     # Defines the data models
   │   ├── menu_list.dart
   │   ├── category.dart
   │   ├── content_data.dart
   │   ├── audio_data.dart
   │   └── lyrics.dart
   │
   ├── providers/                  # Responsible for making API calls
   │   ├── menu_service.dart
   │   └── category_provider.dart
   │
   ├── views/                      # UI components of the app
   │   ├── menu_list_view.dart
   │   ├── category_detail_view.dart
   │   ├── category_item_view.dart
   │   └── lyrics_audio_view.dart
   │
   ├── utils/                      # Holds utility functions and constants
   │   ├── constants.dart
   │   └── helpers.dart
   │
   └── main.dart                   # Entry point for the app
```

## App Flow

1. **Main Menu**:

   - Displays dynamic menu items fetched from an endpoint (`baseUrl/menu`).
   - Each item leads to a unique endpoint for fetching related data.

2. **Category View**:
   - Opens when a menu item is clicked.
   - Fetches categories for the selected menu item and displays them in a list.
3. **Category Item View**:

   - Opens when a category is clicked.
   - Displays individual items under the category. Each item is clickable.

4. **Audio and Lyrics View**:
   - Opens when a category item is selected.
   - Plays associated audio and displays lyrics in three tabbed views (Arabic, Transliteration, and Translation).
   - Audio syncs with the lyrics for a smooth experience.

## Dependencies

- `flutter`: Core Flutter framework
- `get`: State management
- `dio`: For handling HTTP requests
- `provider`: Dependency injection and state management
- `cached_network_image`: Image caching (optional)

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  dio: ^5.1.0
  provider: ^6.0.3
  cached_network_image: ^3.2.0
```
