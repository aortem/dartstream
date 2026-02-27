# DartStream Static Files Sample App

This sample application demonstrates the static file serving capability implemented in the `ds_shelf` middleware package.

## Features

- ✅ Serves static files from the `public/` directory
- ✅ Supports multiple file types (HTML, CSS, JS, SVG, etc.)
- ✅ Correct MIME type headers
- ✅ Default document support (index.html)
- ✅ Mix static files with dynamic API routes

## Running the App

1. **Install dependencies:**

   ```bash
   dart pub get
   ```

2. **Run the server:**

   ```bash
   dart run server.dart
   ```

3. **Open your browser:**
   Navigate to `http://localhost:8080`

## What to Test

### Static Files

- `http://localhost:8080/` - Serves `public/index.html`
- `http://localhost:8080/about.html` - About page
- `http://localhost:8080/styles.css` - CSS stylesheet
- `http://localhost:8080/script.js` - JavaScript file
- `http://localhost:8080/logo.svg` - SVG image

### API Endpoint

- `http://localhost:8080/api/hello` - Dynamic API route

## Implementation

The server uses the new `addStaticRoute()` method:

```dart
final server = DSShelfCore();
server.addStaticRoute('public');
```

This single line enables serving all files from the `public/` directory!

## File Structure

```
example/
├── server.dart          # Backend server
├── pubspec.yaml         # Dependencies
├── public/              # Static files directory
│   ├── index.html       # Main page
│   ├── about.html       # About page
│   ├── styles.css       # Stylesheet
│   ├── script.js        # JavaScript
│   └── logo.svg         # SVG logo
└── README.md            # This file
```

## Verification

The demo page includes:

- ✓ Visual confirmation of loaded files
- ✓ JavaScript execution verification
- ✓ API endpoint testing
- ✓ File type status table

All green checkmarks = Static files working correctly! 🎉
