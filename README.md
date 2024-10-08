# BoB - Financial Literacy Platform

Welcome to the BoB Financial Literacy Platform! This README will guide you through the process of setting up, running, and building the Flutter app. It will also provide an overview of the app's features and functionalities.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Cloning the Repository](#cloning-the-repository)
3. [Setting Up the Environment](#setting-up-the-environment)
4. [Running the App](#running-the-app)
5. [Building the APK](#building-the-apk)
6. [App Features and Functionalities](#app-features-and-functionalities)
7. [Backend Repository](#backend-repository)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for macOS and iOS development, if applicable)
- [Visual Studio Code](https://code.visualstudio.com/) (optional but recommended)
- [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/get-npm) (for backend and API interaction)
- [Git](https://git-scm.com/) (for version control)

## Cloning the Repository

1. Open your terminal (Command Prompt, PowerShell, or any terminal application).
2. Clone the repository using the following command:

    ```bash
    git clone https://github.com/YourUsername/BoB_Flutter_App.git
    ```

3. Navigate into the project directory:

    ```bash
    cd BoB_Flutter_App
    ```

## Setting Up the Environment

1. **Install Dependencies**:

    - Ensure you are in the project directory.
    - Run the following command to install the required Flutter packages:

      ```bash
      flutter pub get
      ```

2. **Configure Android/iOS Development Environment**:

    - For **Android**:
      - Open `android/app/build.gradle` and set the appropriate `applicationId`.
      - Make sure the `android/gradle.properties` file is configured correctly.

    - For **iOS** (macOS only):
      - Open the `ios/Runner.xcworkspace` in Xcode and configure any required settings.

## Running the App

### On Windows

1. Ensure your emulator or device is connected and set up.
2. Run the following command to start the app:

    ```bash
    flutter run
    ```

### On Linux

1. Ensure your emulator or device is connected and set up.
2. Run the following command to start the app:

    ```bash
    flutter run
    ```

### On macOS

1. Ensure your emulator or device is connected and set up.
2. Run the following command to start the app:

    ```bash
    flutter run
    ```

## Building the APK

1. **Prepare the App for Release**:

    - Open the terminal and navigate to the project directory.
    - Run the following command to build the APK:

      ```bash
      flutter build apk --release
      ```

2. **Locate the APK**:

    - After the build completes, you can find the APK file in the `build/app/outputs/flutter-apk/` directory.

## App Features and Functionalities

The BoB Financial Literacy Platform includes the following key features:

1. **Modules Generated by Gemini AI**:
   - **Dynamic Content Generation**: Daily financial advice modules are generated using Gemini AI.
   - **Interactive Widgets**: Users can interact with these modules to receive personalized advice.

2. **Goal Setting**:
   - **Add and Track Goals**: Users can set financial goals and track their progress.
   - **Goal Progress**: Visual representation of goal progress with the ability to update and manage goals.

3. **Savings Management**:
   - **View Total Savings**: Displays the total amount saved by the user.
   - **Add/Withdraw Savings**: Allows users to add or withdraw savings, with the functionality to display recent transactions.

4. **Assessment-Based Advice**:
   - **Take Assessments**: Users can take assessments to receive personalized advice.
   - **View and Manage Assessments**: Track and manage assessment responses and advice based on their performance.

5. **Profile Management**:
   - **View and Update Profile**: Users can view and update their personal information, preferences, and account settings.

6. **Navigation**:
   - **Bottom Navigation Bar**: Quick access to Home, Savings, Goals, and Profile screens with smooth transitions.

## Backend Repository

For more detailed information about the backend setup and configuration, visit the [BoB Node Backend Repository](https://github.com/RobertOdhiz/BoB_Node_Backend/blob/main/README.md).

## Troubleshooting

If you encounter issues, consider the following steps:

1. **Check Dependencies**:
   - Ensure all dependencies are correctly installed and up-to-date.

2. **Verify Configuration**:
   - Check the `.env` file for correct environment variable settings.

3. **Review Logs**:
   - Look at the output in your terminal or IDE for error messages.

4. **Consult Documentation**:
   - Refer to the [Flutter Documentation](https://flutter.dev/docs) and [Dart Documentation](https://dart.dev/guides) for additional help.

5. **Seek Support**:
   - If the issue persists, consider asking for help on forums such as Stack Overflow or the Flutter community.

Feel free to contribute to the project or report any issues you encounter. Happy coding!
