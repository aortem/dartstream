# 🚀 Firebase Auth Demo - Quick Start

Get the Firebase Authentication demo running in under 2 minutes!

## One-Command Launch

```powershell
.\run_demo.ps1
```

That's it! The script will:
- ✅ Install dependencies
- ✅ Start the backend server
- ✅ Open the frontend in your browser

## What to Expect

### 1. Server Starts
You'll see:
```
🚀 Starting Firebase Authentication Demo Server
📱 Initializing Firebase App...
🔐 Initializing Firebase Auth Provider...
✅ Firebase Auth Provider initialized
🔥 Server running at http://0.0.0.0:8080
```

### 2. Browser Opens
The frontend will automatically open showing:
- Firebase-branded login screen
- Orange and yellow gradient design
- Glassmorphic UI elements

### 3. Test the Flow

#### Register a New Account
1. Click **"Create Account"**
2. Enter:
   - Display Name: `Test User`
   - Email: `test@example.com`
   - Password: `password123`
3. Click **"Create Account"**
4. See success message ✅

#### Sign In
1. Enter the same credentials
2. Click **"Sign In"**
3. See your dashboard with user info 🎉

#### Sign Out
1. Click **"Logout"** button
2. Return to login screen

## Expected Results

✅ **Registration**: Account created successfully  
✅ **Login**: Dashboard appears with user details  
✅ **Session**: Refresh page - still logged in  
✅ **Logout**: Returns to login screen  

## Troubleshooting

### Port Already in Use
```powershell
# Find and kill process on port 8080
Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess | Stop-Process
```

### Dependencies Failed
```powershell
# Manually install
dart pub get
```

### Server Won't Start
```powershell
# Run manually to see errors
dart run bin/firebase_server.dart
```

## Manual Testing (Optional)

### Test Health Endpoint
```powershell
Invoke-WebRequest -Uri "http://localhost:8080/health" -Method GET
```

### Test Registration API
```powershell
$body = @{
    email = 'demo@test.com'
    password = 'test123'
    displayName = 'Demo User'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:8080/auth/register' -Method POST -Body $body -ContentType 'application/json'
```

### Test Login API
```powershell
$body = @{
    email = 'demo@test.com'
    password = 'test123'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:8080/auth/login' -Method POST -Body $body -ContentType 'application/json'
```

## Stop the Server

Press **Ctrl+C** in the terminal running the script.

## Next Steps

- See [README.md](README.md) for detailed documentation
- Customize the UI in `client/styles.css`
- Add more endpoints in `bin/firebase_server.dart`
- Configure real Firebase credentials

---

**Need Help?** Check the full [README.md](README.md) for troubleshooting and configuration options.
