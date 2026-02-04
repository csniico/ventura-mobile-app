# Ventura BI Mobile App

A comprehensive business intelligence mobile application built with Flutter, designed to help businesses manage their operations, track performance, and make data-driven decisions.

## Architecture

This project follows **Clean Architecture** principles with **BLoC pattern** for state management:

- **Presentation Layer**: Widgets, BLoCs/Cubits, and UI logic
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Repositories, data sources, and models
- **Core Layer**: Shared utilities, themes, and configurations

### State Management

- **AuthBloc**: Manages authentication session state (singleton)
- **Feature Cubits**: Handle specific flows (login, registration, profile editing, etc.)
- **AppUserCubit**: Manages current user state across the app

## Features

### Authentication & User Management

- Email/password authentication
- Google Sign-In integration
- User registration with email verification
- Password recovery flow
- Profile editing with avatar upload
- Business profile creation

### Business Intelligence

- Invoice management
- Order tracking
- Product catalog
- Customer management
- Sales analytics and reporting
- PDF generation and sharing

### Additional Features

- Offline data storage (SQLite)
- Network connectivity monitoring
- Contact picker integration
- File sharing capabilities
- Calendar integration
- Multi-platform support (iOS, Android, Web, Desktop)

## Tech Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: flutter_bloc 9.1.1, flutter_riverpod 3.0.3
- **Networking**: Dio 5.9.0 with cookie management
- **Database**: SQLite with sqflite
- **Authentication**: Google Sign-In 7.2.0
- **Dependency Injection**: GetIt 9.2.0
- **Functional Programming**: fpdart 1.2.0
- **UI Components**: HugeIcons, table_calendar, flutter_slidable
- **File Operations**: path_provider, image_picker, open_file, share_plus
- **PDF Generation**: pdf 3.11.3

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode for mobile development
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd ventura-mobile-app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Generate launcher icons**

   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Run the app**

   ```bash
   flutter run
   ```

### Build Commands

- **Debug build**: `flutter run`
- **Release build**: `flutter build apk` or `flutter build ios`
- **Web build**: `flutter build web`
- **Run tests**: `flutter test`

## Project Structure

```bash
lib/
├── core/                    # Core functionality
│   ├── data/               # Core data layer
│   ├── domain/             # Core domain layer
│   └── presentation/       # Core UI components
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   │   ├── data/          # Auth data sources & repositories
│   │   ├── domain/        # Auth use cases & entities
│   │   └── presentation/  # Auth UI (pages, widgets, blocs)
│   ├── sales/             # Sales management feature
│   ├── products/          # Product management feature
│   └── customers/         # Customer management feature
├── config/                # App configuration
├── init_dependencies.dart # Dependency injection setup
└── main.dart             # App entry point
```

## Recent Changes

### Authentication Refactoring (v0.0.7)

- **Separated concerns**: Split monolithic AuthBloc into focused feature cubits
- **Improved architecture**: AuthBloc now only manages session state
- **New cubits**:
  - `LoginCubit`: Email/password and Google sign-in
  - `RegistrationCubit`: User registration flow
  - `EmailVerificationCubit`: Email verification process
  - `PasswordRecoveryCubit`: Password reset flow
  - `UserProfileCubit`: Profile editing and avatar upload

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Flutter's [style guide](https://flutter.dev/docs/development/tools/formatting)
- Use `flutter analyze` to check for issues
- Write tests for new features

## License

This project is proprietary software. All rights reserved.

## Support

For support and questions:

- Create an issue in the repository
- Contact the development team
