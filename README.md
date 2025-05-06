# AI Attendance System
🔹 **Version:** 1.0  
🔹 **Tech Stack:** Flutter (Web), Node.js (Backend), MongoDB (Database)

## 📌 Project Overview

A modern attendance tracking system with web interface built using Flutter Web. The system provides real-time attendance management with features like check-in/check-out tracking and user authentication.

### 🔹 Key Features
- ✅ JWT-based Authentication
- ✅ Real-time Attendance Tracking
- ✅ Modern Material Design UI
- ✅ Role-based Access Control (Admin/User)
- ✅ Attendance History & Reports

## 📌 System Architecture

```plaintext
+------------------+       +------------------+       +------------------+
|  Flutter Web UI  |  <--->|  Node.js API     |  <--->|     MongoDB      |
+------------------+       +------------------+       +------------------+
```

### 🔹 Technology Stack
- **Frontend:** Flutter Web
- **Backend:** Node.js + Express.js
- **Database:** MongoDB
- **Authentication:** JWT

## 📌 Setup Instructions

### Prerequisites
- Node.js v23.7.0+
- MongoDB running on localhost:27017
- Flutter SDK
- Chrome browser for development

### Backend Setup
```bash
# Navigate to server directory
cd server

# Install dependencies
npm install

# Start the server
node src/index.js
```

### Frontend Setup
```bash
# Navigate to Flutter project
cd client/smart_lock

# Get Flutter dependencies
flutter pub get

# Run the web app
flutter run -d chrome
```

## 📌 API Endpoints

### Authentication Routes
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | User login |
| POST | `/api/auth/register` | User registration |
| GET | `/api/auth/profile` | Get user profile |

### Attendance Routes
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/attendance/check-in` | Record check-in |
| POST | `/api/attendance/check-out` | Record check-out |
| GET | `/api/attendance/history` | View attendance history |

## 📌 Database Schema

### Users Collection
```javascript
{
  _id: ObjectId,
  name: String,
  email: String,
  password: String (hashed),
  role: String (enum: ['user', 'admin']),
  createdAt: Timestamp
}
```

### Attendance Collection
```javascript
{
  _id: ObjectId,
  userId: ObjectId,
  checkIn: Timestamp,
  checkOut: Timestamp,
  status: String (enum: ['Present', 'Late', 'Left']),
  date: Date
}
```

## 📌 Common Issues & Solutions

### Backend Issues
1. **Port 3000 Already in Use**
   ```bash
   # Kill existing Node processes
   taskkill /F /IM node.exe
   ```

2. **Missing Dependencies**
   ```bash
   cd server
   npm install
   ```

### Frontend Issues
1. **Shared Preferences Package Error**
   - Update pubspec.yaml with correct package name
   - Run `flutter pub get`

2. **Connection to Backend Failed**
   - Ensure backend is running on port 3000
   - Check CORS configuration in backend
   - Verify API endpoint URLs

## 📌 Development Guidelines

### Code Structure
```
project/
├── server/
│   ├── src/
│   │   ├── index.js
│   │   ├── models/
│   │   ├── routes/
│   │   └── middleware/
│   └── package.json
└── client/
    └── smart_lock/
        ├── lib/
        │   ├── main.dart
        │   ├── screens/
        │   └── services/
        └── pubspec.yaml
```

### Security Measures
- JWT for authentication
- Password hashing with bcrypt
- Rate limiting on API endpoints
- CORS protection
- Input validation

## 📌 Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📌 License
This project is licensed under the MIT License.

## 📌 UI/UX Design Guidelines

### 🎨 Design System

#### Color Palette
```scss
// Primary Colors
$primary-blue: #2196F3;      // Main brand color
$primary-dark: #1976D2;      // Dark variant
$primary-light: #BBDEFB;     // Light variant

// Secondary Colors
$accent-green: #4CAF50;      // Success states
$accent-red: #F44336;        // Error states
$accent-amber: #FFC107;      // Warning states

// Neutral Colors
$background-light: #FFFFFF;   // Light theme background
$background-dark: #121212;    // Dark theme background
$surface-light: #F5F5F5;     // Light theme surface
$surface-dark: #1E1E1E;      // Dark theme surface

// Text Colors
$text-primary-light: rgba(0, 0, 0, 0.87);    // Light theme primary text
$text-primary-dark: rgba(255, 255, 255, 0.87);// Dark theme primary text
```

#### Typography
```dart
// Font Families
fontFamily: 'Roboto',  // Primary font
fontFamily: 'Inter',   // Secondary font

// Text Styles
headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
```

### 📱 Component Library

#### Core Components
1. **AppBar**
   - Responsive header with navigation menu
   - User profile section
   - Quick action buttons

2. **Dashboard Cards**
   ```dart
   Container(
     padding: EdgeInsets.all(16.0),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(12.0),
       boxShadow: [
         BoxShadow(
           color: Colors.black12,
           blurRadius: 10.0,
         ),
       ],
     ),
   )
   ```

3. **Data Tables**
   - Sortable columns
   - Pagination controls
   - Row selection
   - Action buttons

4. **Status Badges**
   ```dart
   Chip(
     label: Text('Present'),
     backgroundColor: Colors.green[100],
     labelStyle: TextStyle(color: Colors.green[900]),
   )
   ```

### 🎯 Screen Layouts

#### 1. Login Screen
- Clean, centered form layout
- Social login options
- Password recovery link
- Remember me checkbox

#### 2. Dashboard
- Grid layout for statistics cards
- Recent activity timeline
- Quick action buttons
- Attendance status overview

#### 3. Attendance Table
- Search and filter options
- Column customization
- Export functionality
- Bulk actions menu

### 🌓 Theme Support

```dart
ThemeData(
  brightness: Brightness.light, // or Brightness.dark
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
)
```

### 📱 Responsive Design Breakpoints

```dart
class Responsive {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}
```

### ♿ Accessibility Features
- High contrast text options
- Screen reader support
- Keyboard navigation
- Focus indicators
- WCAG 2.1 compliance

### 🔄 Loading States
- Shimmer effect for data loading
- Progress indicators
- Skeleton screens
- Pull-to-refresh

### ⚡ Micro-interactions
- Button hover effects
- Form field focus animations
- Page transitions
- Success/error feedback

### 📊 Data Visualization
- Attendance trends charts
- User activity graphs
- Department statistics
- Performance metrics 