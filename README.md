# 🍳 Recipe App

A Flutter application that allows users to browse and discover delicious recipes from around the world. The app features a modern, intuitive interface with detailed recipe information, ingredients, instructions, and video tutorials.

## ✨ Features

- **Browse Recipes**: Explore a wide variety of recipes from different categories and cuisines
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

### Installation

1. Clone the repository
```bash
git clone https://github.com/anaaleksova/MIS_lab2
cd MIS_lab2
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

- `url_launcher` - For opening YouTube links in web view

## 🏗️ Project Structure

```
lib/
├── models/
│   ├── category.dart            # Category model
│   ├── meal.dart                # Meal preview model
│   └── meal_detail.dart         # Detailed recipe data model
├── screens/
│   ├── categories_screen.dart   # Categories browsing screen
│   ├── meal_detail_screen.dart  # Recipe detail screen
│   └── meals_screen.dart        # Meals list screen
├── services/
│   └── api_service.dart         # API integration service
├── widgets/
│   ├── category_card.dart       # Category card widget
│   └── meal_card.dart           # Meal card widget
└── main.dart                     # App entry point                   
```

## 📄 API Reference

The app integrates with a recipe API that provides:

- Recipe details by ID
- Recipe categories
- Recipe search functionality
- Ingredient information
