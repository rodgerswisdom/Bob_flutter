# bob

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# Bob_flutter



```
# BoB Financial Literacy App

BoB is an AI-driven financial literacy app designed to help users improve their financial knowledge and management skills. This README provides an overview of the project's folder structure and setup.

## Folder Structure

The Flutter project is organized into the following directory structure:

```
lib/
├── models/                  # Contains data models for API responses
│   ├── user.dart            # User data model
│   ├── assessment.dart      # Assessment questions and answers data models
│   ├── goal.dart            # Financial goals data model
│   ├── chat.dart            # Chat conversations and messages data models
│   ├── saving.dart          # Savings records data model
│   └── module.dart          # Educational modules data model
├── services/                # Contains classes for interacting with the API
│   ├── api_service.dart     # General API service
│   ├── user_service.dart    # User-related API calls
│   ├── assessment_service.dart  # Assessment-related API calls
│   ├── goal_service.dart    # Financial goals API calls
│   ├── chat_service.dart    # Chat-related API calls
│   ├── saving_service.dart  # Savings records API calls
│   └── module_service.dart  # Educational modules API calls
├── screens/                 # Contains UI screens of the app
│   ├── login_screen.dart    # Login screen
│   ├── register_screen.dart # Registration screen
│   ├── home_screen.dart     # Home screen
│   ├── assessment_screen.dart # Assessment questions screen
│   ├── goals_screen.dart    # Financial goals screen
│   ├── chats_screen.dart    # Chat conversations screen
│   ├── savings_screen.dart  # Savings records screen
│   └── modules_screen.dart  # Educational modules screen
├── widgets/                 # Contains reusable widgets
│   ├── custom_button.dart   # Custom button widget
│   ├── input_field.dart     # Custom input field widget
│   └── chat_bubble.dart     # Chat bubble widget
├── utils/                   # Contains utility functions and constants
│   ├── constants.dart       # Application constants
│   ├── helpers.dart         # Helper functions
│   └── api_constants.dart    # API endpoint paths and keys
└── main.dart                # Entry point of the app
```

## Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/bob-financial-literacy-app.git
   cd bob-financial-literacy-app
   ```

2. **Install Dependencies**

   Make sure you have Flutter installed and run:

   ```bash
   flutter pub get
   ```

3. **Run the App**

   ```bash
   flutter run
   ```

## API Endpoints

Refer to the `API Endpoints` document for details on the available backend APIs.

---

For further details and documentation, please refer to the respective files and directories within the project.

```
