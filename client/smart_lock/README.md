# Smart Lock System

A modern Flutter web application for managing door access control through card scanning and face recognition.

## Features

- **Quick Access Methods**
  - Card Scanning
  - Face Recognition

- **Real-time Activity Tracking**
  - View recent door access history
  - Success/failure status indicators
  - Timestamp tracking

- **User Management**
  - Profile management
  - Access history
  - Real-time notifications

## Getting Started

### Prerequisites

- Flutter SDK (>=3.1.3)
- Chrome browser for web development
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd smart_lock
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the web application:
```bash
flutter run -d chrome
```

### Project Structure

```
lib/
├── main.dart              # Application entry point
├── screens/              
│   ├── user/             # User-specific screens
│   │   └── home_screen.dart
│   ├── worker/           # Worker-specific screens
│   └── admin/            # Admin-specific screens
└── widgets/              # Reusable widgets
```

## Usage

1. **Quick Access**
   - Use the card scanning feature by clicking the "Scan Card" button
   - Use face recognition by clicking the "Face Recognition" button

2. **View History**
   - Navigate to the History tab to view all access attempts
   - Each entry shows the timestamp and access status

3. **Notifications**
   - Click the bell icon to view notifications
   - Unread notifications are highlighted
   - Click "Mark all as read" to clear notifications

## Development

The project uses the following packages:
- `flutter_lints` for code quality
- `google_fonts` for typography
- `provider` for state management
- `shared_preferences` for local storage
- `http` for API communication
- `intl` for date formatting

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
