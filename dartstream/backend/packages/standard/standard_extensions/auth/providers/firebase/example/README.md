# Firebase Authentication Demo

A complete sample application demonstrating Firebase Authentication integration with DartStream, featuring a Dart backend and modern web frontend.

## 🎯 Overview

This demo showcases:
- **Backend**: Dart server using Shelf framework with Firebase Auth Provider
- **Frontend**: Modern web UI with glassmorphic design and Firebase branding
- **Features**: User registration, login, logout, and session management
- **One-Command Launch**: Start both backend and frontend together

### Development Mode

By default, the app runs in **development mode** which simulates Firebase authentication without requiring real Firebase credentials. This allows you to:
- Test the complete authentication flow
- See the UI and user experience
- Understand the API structure
- Demo the application without Firebase setup

To use real Firebase credentials, set `kIsDev = false` in `bin/firebase_server.dart` and provide actual Firebase environment variables.

## 📋 Prerequisites

- Dart SDK 3.0.0 or higher
- Modern web browser (Chrome, Firefox, Edge, Safari)
- PowerShell (for Windows)

## 🚀 Quick Start

### Option 1: One-Command Launch (Recommended)

```powershell
.\run_demo.ps1
```

This script will:
1. Install all dependencies
2. Start the backend server on port 8080
3. Open the frontend in your default browser
4. Display server logs in real-time

### Option 2: Manual Launch

#### Start Backend
```bash
# Install dependencies
dart pub get

# Run server
dart run bin/firebase_server.dart
```

#### Open Frontend
Open `client/index.html` in your web browser or use a local server:
```bash
# Using Python
python -m http.server 3000 --directory client

# Using Node.js
npx serve client
```

## 🎨 Features

### Backend API

The server provides the following REST endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/auth/register` | Create new user account |
| POST | `/auth/login` | Sign in with email/password |
| GET | `/auth/session` | Get current user session |
| POST | `/auth/logout` | Sign out user |

### Frontend Features

- **Modern UI**: Glassmorphic design with Firebase branding
- **Responsive**: Works on desktop and mobile devices
- **Animated**: Smooth transitions and micro-animations
- **Session Persistence**: Automatic session restoration
- **Error Handling**: User-friendly error messages
- **Real-time Feedback**: Loading states and success alerts

## 📝 Usage Guide

### 1. Register a New Account

1. Click "Create Account" button
2. Enter your display name, email, and password
3. Click "Create Account"
4. You'll see a success message

### 2. Sign In

1. Enter your registered email and password
2. Click "Sign In"
3. You'll be redirected to the dashboard

### 3. View Dashboard

After logging in, you'll see:
- Your display name and email
- Your user ID
- Authentication status
- Success confirmation

### 4. Sign Out

Click the "Logout" button in the dashboard to sign out.

## 🔧 Configuration

### Environment Variables

The backend supports the following environment variables for real Firebase configuration:

```bash
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_STORAGE_BUCKET=your-bucket
FIREBASE_APP_ID=your-app-id
FIREBASE_SERVICE_ACCOUNT_PATH=path/to/service-account.json
```

**Note**: If not provided, the app uses mock credentials for testing.

### Using Real Firebase

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Email/Password authentication
3. Download service account key
4. Set environment variables
5. Restart the server

## 🧪 Testing

### Test Registration Flow

```powershell
$body = @{
    email = 'test@example.com'
    password = 'password123'
    displayName = 'Test User'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:8080/auth/register' -Method POST -Body $body -ContentType 'application/json'
```

### Test Login Flow

```powershell
$body = @{
    email = 'test@example.com'
    password = 'password123'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:8080/auth/login' -Method POST -Body $body -ContentType 'application/json'
```

### Test Session Check

```powershell
$headers = @{
    Authorization = 'Bearer YOUR_SESSION_ID'
}

Invoke-RestMethod -Uri 'http://localhost:8080/auth/session' -Method GET -Headers $headers
```

## 🏗️ Architecture

### Backend Structure

```
example/
├── bin/
│   └── firebase_server.dart    # Main server file
├── client/
│   ├── index.html              # Frontend HTML
│   ├── styles.css              # Styling
│   └── app.js                  # Frontend logic
├── pubspec.yaml                # Dependencies
└── run_demo.ps1                # Launch script
```

### Data Flow

1. **Registration**: Frontend → POST /auth/register → Firebase Provider → Success
2. **Login**: Frontend → POST /auth/login → Firebase Provider → Session ID → Frontend
3. **Session Check**: Frontend → GET /auth/session → Validate Session → User Data
4. **Logout**: Frontend → POST /auth/logout → Clear Session → Success

## 🎨 Design

The frontend features:
- **Firebase Colors**: Orange (#FF6F00) and Yellow (#FFCA28)
- **Dark Theme**: Modern dark background with gradients
- **Glassmorphism**: Frosted glass effect with backdrop blur
- **Animations**: Smooth transitions and loading states
- **Typography**: Inter font family for clean readability

## 🐛 Troubleshooting

### Server won't start

- Check if port 8080 is already in use
- Ensure Dart SDK is properly installed
- Run `dart pub get` to install dependencies

### Frontend can't connect to backend

- Verify server is running on http://localhost:8080
- Check browser console for CORS errors
- Ensure firewall isn't blocking the connection

### Authentication errors

- Check server logs for detailed error messages
- Verify Firebase credentials if using real Firebase
- Ensure email/password meet requirements (password min 6 chars)

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [DartStream Documentation](https://dartstream.dev)
- [Shelf Framework](https://pub.dev/packages/shelf)

## 📄 License

This example is part of the DartStream project and follows the same license.
