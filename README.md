# 🍳 Recipe App

A Flutter application that allows users to browse and discover delicious recipes from around the world. The app features a modern, intuitive interface with detailed recipe information, ingredients, instructions, and video tutorials.

## ✨ Features

- **Browse Recipes**: Explore a wide variety of recipes from different categories and cuisines
- **Search Functionality**: Search for meals by name or filter categories
- **Favorites System**: Save your favorite recipes
- **Random Recipe**: Discover new recipes with the random recipe generator
- **Daily Notifications**: Get notified daily at 10:00 AM with a "Recipe of the Day" reminder

- **Detailed Recipe View**: View comprehensive recipe information including:
  - High-quality food images with hero animations
  - Category and cuisine tags
  - Complete list of ingredients with measurements
  - Step-by-step cooking instructions
  - YouTube video tutorials (opens in in-app web view)
- **Modern UI**: Clean and attractive user interface with smooth animations

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing
- Firebase account and project setup

### Installation

1. Clone the repository
```bash
git clone https://github.com/anaaleksova/MIS-lab3
cd MIS-lab3
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📦 Dependencies

The app uses the following packages:
- `flutter_local_notifications` - Local notification scheduling
- `firebase_core` - Firebase initialization
- `firebase_messaging` - Push notifications
- `cloud_firestore` - Cloud database for favorites
- `http` - API requests
- `url_launcher` - For opening YouTube links in web view

## 🏗️ Project Structure

```
lib/
├── models/
│   ├── category.dart            # Category model
│   ├── meal.dart                # Meal preview model
│   └── meal_detail.dart         # Detailed recipe data model
│   └── favorite_meal.dart       # Favorite meal model
├── screens/
│   ├── categories_screen.dart   # Categories browsing screen
│   ├── meal_detail_screen.dart  # Recipe detail screen
│   └── meals_screen.dart        # Meals list screen
│   └── favorites_screen.dart    # Saved favorites screen
├── services/
│   └── api_service.dart         # API integration service
│   ├── favorites_service.dart   # Firestore favorites management
│   └── notification_service.dart # Local & push notification handling
├── widgets/
│   ├── category_card.dart       # Category card widget
│   └── meal_card.dart           # Meal card widget
│   └── favorite_meal_card.dart  # Favorite meal card widget
├── firebase_options.dart         # Firebase configuration (auto-generated)
└── main.dart                     # App entry point                   
```

## 📄 API Reference

The app integrates with a recipe API that provides:

- Recipe details by ID
- Recipe categories
- Recipe search functionality
- Ingredient information

## 🔔 Notifications

### Daily Recipe Notifications
- Scheduled to trigger daily at 10:00 AM
- Reminds users to discover a new random recipe of the day
- Uses local notifications with timezone support

### Testing Notifications
A test notification function is included that triggers 20 seconds after app launch for testing purposes.

