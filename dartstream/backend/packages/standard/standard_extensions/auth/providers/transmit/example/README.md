# Transmit Authentication Demo

## Quick Start

Run both backend and frontend with a single command:

```powershell
# Install dependencies first
dart pub get
npm install

# Run the app
npm run dev
```

Then open http://localhost:4000 in your browser.

## What This Demo Does

This example demonstrates the Transmit authentication provider integration:

- **Backend**: Dart server using `ds_transmit_auth_provider` with endpoints for login, logout, session management, and token refresh
- **Frontend**: Modern web UI with authentication flows
- **Integration**: Full authentication cycle testing

## Features

✅ User login with email/password  
✅ Session management  
✅ Token refresh  
✅ Logout functionality  
✅ Modern, responsive UI  

## Testing

In development mode, any email and password combination will work. The provider uses mock authentication from the Transmit SDK.

## API Endpoints

- `POST /auth/login` - Authenticate user
- `GET /auth/session` - Check current session
- `POST /auth/logout` - End session
- `POST /auth/refresh` - Refresh access token
- `GET /health` - Health check

## Architecture

```
example/
├── bin/
│   └── transmit_server.dart    # Backend server
├── client/
│   ├── index.html              # Frontend UI
│   ├── styles.css              # Styling
│   └── app.js                  # Client logic
├── pubspec.yaml                # Dart dependencies
└── package.json                # npm scripts
```

## Manual Testing

1. Start the server: `dart run bin/transmit_server.dart`
2. Open http://localhost:4000
3. Enter any email and password
4. Click "Sign In"
5. Test token refresh and logout

## Next Steps

- Configure real Transmit API credentials in production
- Add error handling for network failures
- Implement secure token storage
- Add user registration flow
