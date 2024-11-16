# Flutter Dynamic Content App

This Flutter app dynamically fetches and displays structured content from APIs. It is built on a modular architecture that emphasizes separation of concerns, with well-defined components for data management, business logic, and UI rendering.

---

## Features

- **Dynamic Main Menu**: Displays a list of menu items fetched from an API (e.g., "Daily Dua", "Surah"). Clicking on a menu item leads to a category view.
- **Category View**: Shows categories related to the selected menu item, fetched from a corresponding API.
- **Category Item View**: Lists items within a category. Each item includes audio and lyrics.
- **Audio and Lyrics View**: Plays audio and displays synchronized lyrics in three tabs: Arabic, Transliteration, and Translation.

---

## Folder Structure

The app's folder structure is organized as follows:

```
   lib
   ├── controllers
   │   ├── animated_text_controller.dart
   │   ├── category_detail_controller.dart
   │   ├── category_list_controller.dart
   │   └── menu_list_controller.dart
   ├── main.dart
   ├── modals
   │   ├── animated_text.dart
   │   ├── category.dart
   │   ├── category_response.dart
   │   ├── content_data.dart
   │   └── menu_list.dart
   ├── providers
   │   ├── animated_text_provider.dart
   │   ├── category_provider.dart
   │   └── menu_provider.dart
   ├── utils
   │   ├── colors.dart
   │   ├── constants.dart
   │   └── styles.dart
   ├── views
   │   ├── category_detail_view.dart
   │   ├── category_list_view.dart
   │   ├── lyrics_tab.dart
   │   ├── main_menu_view.dart
   │   ├── menu_detail_view.dart
   │   └── menu_list_view.dart
   └── widgets
      ├── audio_player_widget.dart
      ├── background_wrapper.dart
      ├── custom_appbar.dart
      └── marquee_appbar.dart

```

---

## App Flow

1. **Main Menu**:

   - Displays menu items fetched from an API endpoint.
   - Each item navigates to a category view with content fetched dynamically.

2. **Category View**:

   - Lists categories associated with the selected menu item.
   - Clicking a category navigates to the category item view.

3. **Category Item View**:

   - Displays titles under the selected category.
   - Clicking a title opens the lyrics and audio view.

4. **Audio and Lyrics View**:
   - Plays audio synchronized with the lyrics.
   - Lyrics are displayed across three tabs: Arabic, Transliteration, and Translation.

---

## Dependencies

The following dependencies are used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5 # State management
  dio: ^5.1.0 # HTTP requests
  provider: ^6.0.3 # Dependency injection and state management
  cached_network_image: ^3.2.0 # Image caching
  audioplayers: ^0.20.1 # Audio playback
  marquee: ^2.3.0 # Marquee Text
```
