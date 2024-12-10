---
# Flutter Dynamic Content App

This Flutter app dynamically fetches and displays structured content from APIs. It follows a modular architecture that emphasizes separation of concerns, with well-defined components for data management, business logic, and UI rendering.
---

## Features

- **Dynamic Main Menu**: Displays a list of menu items fetched from an API (e.g., "Daily Dua", "Surah"). Clicking on a menu item leads to a category view.
- **Category View**: Shows categories related to the selected menu item, fetched from a corresponding API.
- **Category Item View**: Lists items within a category. Each item includes audio and lyrics.
- **Audio and Lyrics View**: Plays audio and displays synchronized lyrics in three tabs: Arabic, Transliteration, and Translation.
- **User Features**: Includes user login, profile management, and password updates.

---

## Folder Structure

The app's folder structure is organized as follows:

```
lib
├── controllers
│   ├── about_us_controller.dart
│   ├── animated_text_controller.dart
│   ├── category_detail_controller.dart
│   ├── category_list_controller.dart
│   ├── daily_date_controller.dart
│   ├── event_popup_controller.dart
│   ├── favourite_controller.dart
│   ├── login_controller.dart
│   ├── menu_list_controller.dart
│   ├── password_update_controller.dart
│   ├── prayer_time_controller.dart
│   ├── regestration_controller.dart
│   ├── text_cleaner_controller.dart
│   └── user_info_controller.dart
├── main.dart
├── modals
│   ├── about_us_response.dart
│   ├── animated_text.dart
│   ├── category.dart
│   ├── category_response.dart
│   ├── content_data.dart
│   ├── daily_date.dart
│   ├── event_popup_model.dart
│   ├── favourite_model.dart
│   ├── login_response.dart
│   ├── menu_list.dart
│   ├── prayer_time_model.dart
│   ├── registration_response.dart
│   ├── update_password.dart
│   └── user_info.dart
├── providers
│   ├── about_us_provider.dart
│   ├── animated_text_provider.dart
│   ├── category_provider.dart
│   ├── dailydate_provider.dart
│   ├── event_popup_provider.dart
│   ├── favourite_provider.dart
│   ├── login_provider.dart
│   ├── menu_provider.dart
│   ├── password_update_provider.dart
│   ├── prayer_time_provider.dart
│   ├── regestration_provider.dart
│   └── user_info_provider.dart
├── utils
│   ├── colors.dart
│   ├── constants.dart
│   └── styles.dart
├── views
│   ├── about_us_view.dart
│   ├── category_detail_view.dart
│   ├── category_list_view.dart
│   ├── event_popup_view.dart
│   ├── fav_category_list_view.dart
│   ├── fav_menu_list_view.dart
│   ├── login_view.dart
│   ├── lyrics_tab.dart
│   ├── main_menu_view.dart
│   ├── menu_detail_view.dart
│   ├── menu_list_view.dart
│   ├── profile_view.dart
│   ├── profile_view_change_password.dart
│   ├── settings_page_view.dart
│   ├── signup_or_login_view.dart
│   └── signup_view.dart
└── widgets
    ├── audio_player_widget.dart
    ├── background_wrapper.dart
    ├── custom_appbar.dart
    ├── custom_drawer.dart
    ├── daily_date_widget.dart
    ├── labeled_input_field_widget.dart
    ├── marquee_appbar.dart
    ├── prayer_time_widget.dart
    └── search_bar_widget.dart
```

---

## App Flow

1. **Main Menu**:

   - Displays a dynamic list of menu items fetched from an API.
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

5. **User Features**:
   - Login and user registration via dedicated controllers and views.
   - Profile management and password updates.

---

## Dependencies

The following dependencies are used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8 # Cupertino Icons for iOS style
  dio: ^5.7.0 # HTTP requests
  get: ^4.6.6 # State management with GetX
  audioplayers: ^6.1.0 # Audio playback
  scrollable_positioned_list: ^0.3.8 # Scrollable list widget
  marquee: ^2.3.0 # Marquee Text
  intl: ^0.19.0 # Internationalization
  keep_screen_on: ^3.0.0 # Prevent screen from turning off
  shimmer: ^3.0.0 # Shimmer effect for loading states
  shared_preferences: ^2.3.3 # Storing simple data locally
  flutter_launcher_icons: ^0.14.1 # For custom app icons
  flutter_expandable_fab: ^2.3.0 # Floating action button with expandable options
  connectivity_plus: ^6.1.0 # Check network connectivity
  geolocator: ^13.0.2 # Location services
```

---
