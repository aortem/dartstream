# EntraID Authentication Demo

A full-stack sample application demonstrating the EntraID authentication provider for DartStream.

## Features

- 🔐 User registration and login
- 👤 User profile display
- 🚪 Secure logout
- 🎨 Modern, premium UI with dark theme
- 🔄 Real-time authentication state management

## Architecture

- **Backend**: Dart HTTP server (port 8080) using Shelf framework
- **Frontend**: React + Vite application (port 5173)
- **Authentication**: EntraID provider with mock authentication

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (3.10.7 or higher)
- [Node.js](https://nodejs.org/) (18.x or higher)
- [npm](https://www.npmjs.com/) (comes with Node.js)

## Quick Start

### Start Both Servers

```powershell
cd example
npm run dev
```

This will:
- Start the backend server on http://localhost:8080
- Start the frontend dev server on http://localhost:5173
- Both servers run concurrently

Press `Ctrl+C` to stop both servers.

**First time only:**
```powershell
cd example
npm run install-all
npm run dev
```

Then open your browser to http://localhost:5173

### Available Commands

- `npm run dev` - Start both servers (recommended)
- `npm run backend` - Start only backend server
- `npm run frontend` - Start only frontend server  
- `npm run install-all` - Install all dependencies

### Manual Setup (Advanced)

#### 1. Start the Backend Server

```powershell
# Install dependencies
dart pub get

# Run the server
dart run bin/server.dart
```

The backend will start on http://localhost:8080

#### 2. Start the Frontend Application

In a new terminal:

```powershell
# Navigate to frontend directory
cd entraid-app

# Install dependencies
npm install

# Start dev server
npm run dev
```

The frontend will start on http://localhost:5173

## Usage

### Register a New Account

1. Click the "Register" tab
2. Enter your display name, email, and password
3. Click "Create Account"
4. You'll see a success message

### Login

1. Click the "Login" tab
2. Enter your email and password
3. Click "Login"
4. Your profile will be displayed

### View Profile

After logging in, you'll see:
- Your display name and email
- User ID
- Provider information (EntraID)
- Tenant ID
- Account creation timestamp

### Logout

Click the "Logout" button to sign out and return to the login screen.

## API Endpoints

### Backend Server (http://localhost:8080)

- `POST /api/auth/register` - Create a new user account
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "displayName": "John Doe"
  }
  ```

- `POST /api/auth/login` - Authenticate user
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- `POST /api/auth/logout` - Sign out current user

- `GET /api/auth/user` - Get current user profile

- `GET /api/auth/verify` - Verify authentication token
  - Header: `Authorization: Bearer <token>`

- `GET /health` - Health check endpoint

## Project Structure

```
example/
├── bin/
│   └── server.dart          # Backend server
├── entraid-app/
│   ├── src/
│   │   ├── App.jsx          # Main React component
│   │   ├── api.js           # API client
│   │   ├── main.jsx         # React entry point
│   │   └── index.css        # Styles
│   ├── index.html           # HTML entry point
│   ├── package.json         # Frontend dependencies
│   └── vite.config.js       # Vite configuration
├── pubspec.yaml             # Backend dependencies
├── run_demo.ps1             # Automated setup script
└── README.md                # This file
```

## Troubleshooting

### Port Already in Use

If port 8080 or 5173 is already in use:

**Backend (8080):**
- Stop any other services using port 8080
- Or modify the port in `bin/server.dart`

**Frontend (5173):**
- Vite will automatically try the next available port
- Or modify the port in `vite.config.js`

### CORS Errors

The backend includes CORS headers to allow frontend communication. If you still see CORS errors:
- Ensure both servers are running
- Check that the frontend is making requests to `http://localhost:8080`
- Verify the backend CORS configuration in `bin/server.dart`

### Dependencies Not Installing

**Dart:**
```powershell
dart pub get --verbose
```

**Node.js:**
```powershell
cd entraid-app
npm install --verbose
```

### Backend Not Starting

- Ensure Dart SDK is installed: `dart --version`
- Check for syntax errors: `dart analyze`
- Verify dependencies are installed

### Frontend Not Starting

- Ensure Node.js is installed: `node --version`
- Clear node_modules and reinstall:
  ```powershell
  rm -r node_modules
  npm install
  ```

## Development

### Backend Development

The backend uses the EntraID authentication provider with mock authentication for testing. In production, you would configure it with real Azure AD B2C credentials.

### Frontend Development

The frontend is built with React and uses modern features:
- Hooks for state management
- Fetch API for HTTP requests
- CSS custom properties for theming
- Responsive design

### Styling

The application uses a premium dark theme with:
- Glassmorphism effects
- Gradient accents
- Smooth animations
- Responsive layout

## License

This example application is part of the DartStream project.
