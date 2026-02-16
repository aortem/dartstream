# Quick Start Guide

## First Time Setup

Run this once to install all dependencies:

```powershell
npm run install-all
```

## Start Both Servers

Run this command to start both backend and frontend:

```powershell
npm run dev
```

This will:
- ✅ Start backend server on http://localhost:8080
- ✅ Start frontend server on http://localhost:5173
- ✅ Both run concurrently in the same terminal

Press `Ctrl+C` to stop both servers.

## Available Commands

- `npm run dev` - Start both servers
- `npm run backend` - Start only backend server
- `npm run frontend` - Start only frontend server
- `npm run install-all` - Install all dependencies

## Testing the App

1. Run `npm run dev`
2. Open browser to http://localhost:5173
3. Register a new account
4. Login with your credentials
5. View your profile
6. Logout
