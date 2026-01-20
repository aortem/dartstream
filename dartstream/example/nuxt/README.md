# DartStream Nuxt Sample App – QA Testing Guide

This sample Nuxt application is used to **test DartStream authentication providers** in a safe DEV/E2E environment. It works with the DartStream `dev_server.dart` and supports **all auth providers** through a provider-agnostic flow.

---

## 📦 What This Sample App Does

* Demonstrates how a frontend (Nuxt) integrates with DartStream Auth
* Allows QA to test **login, session, logout** flows
* Works with **multiple auth providers** (Okta, Auth0, Cognito, Transmit, EntraID, Ping, Fingerprint)
* Uses **DEV + E2E mode** (no real external auth calls)
* Includes Cypress E2E tests

---

## 🧱 Architecture Overview

```
Nuxt App (Frontend)
   |
   |  POST /auth/sign-in
   |  GET  /auth/session
   |  POST /auth/logout
   v
DartStream dev_server.dart (Shelf)
   |
   |  Provider-agnostic auth handling
   |  In-memory session store (DEV only)
   v
DartStream Auth SDK Providers (mocked in DEV)
```

> ⚠️ **Important**: No real external auth provider is contacted in DEV/E2E mode.

---

## ✅ Prerequisites

* Node.js 18+
* Dart SDK 3.x
* npm or pnpm
* Git

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository

```bash
git clone <REPO_URL>
cd dartstream-opensource
```

### 2️⃣ Switch to the sample app Branch

```bash
git checkout feat/nuxt-sample-app
```

---

## 🖥️ Run the DartStream Dev Server

From the **dartstream_backend** directory:

```bash
cd dartstream_backend
dart run bin/dev_server.dart
```

You should see:

```
🚀 Starting DartStream Dev Server (DEV=true)
✅ All auth providers initialized & registered
🔥 Server running at http://localhost:8080
```

---

## 🌐 Run the Nuxt Sample App

From the sample app directory:

```bash
cd example/nuxt
npm install
npm run dev
```

Open your browser:

👉 [http://localhost:3000](http://localhost:3000)

---

## 🔐 Authentication Flow (How Testing Works)

### Login

* The app sends a request to:

```
POST http://localhost:8080/auth/sign-in
```

* Payload includes:

```json
{
  "email": "test@dartstream.dev",
  "password": "password123",
  "provider": "okta",
  "__e2e__": true
}
```

* `__e2e__ = true` tells DartStream to:

  * Skip real provider calls
  * Return a mocked user
  * Still exercise the SDK integration path

---

### Session

After login, the frontend calls:

```
GET http://localhost:8080/auth/session
```

* Session is stored using an **HTTP-only cookie**
* User is restored on page refresh

---

### Logout

```
POST http://localhost:8080/auth/logout
```

* Session cookie is cleared
* User is logged out

---

## 🔄 Testing Different Auth Providers

DartStream supports multiple providers.

### Option 1: Set Environment Variable

```bash
export DS_AUTH_PROVIDER=auth0
```

(or on Windows PowerShell)

```powershell
$env:DS_AUTH_PROVIDER="auth0"
```

Supported values:

* `okta`
* `auth0`
* `cognito`
* `firebase`
* `stytch`
* `magic`
* `transmit`
* `entraid`
* `ping`
* `fingerprint`

---

### Option 2: Cypress Override

Cypress tests can explicitly select a provider:

```ts
cy.login({ provider: 'cognito' })
```

---

## 🧪 Running Cypress Tests

From the Nuxt app directory:

```bash
npx cypress open
```

or headless:

```bash
npx cypress run
```

What Cypress tests:

* Provider-agnostic login
* Session persistence
* Logout
* Dashboard access

---

## 🛡️ DEV / E2E Mode Notes

* Providers are **initialized but mocked**
* No real credentials required
* In-memory session store (resets on server restart)
* Safe for QA testing

> ❌ Not production-ready

---

## 📁 Key Files to Know

| File                          | Purpose                         |
| ----------------------------- | ------------------------------- |
| `bin/dev_server.dart`         | Shelf auth server (DEV only)    |
| `cypress/support/commands.ts` | Provider-agnostic auth commands |
| `pages/auth/login.vue`        | Login UI                        |
| `middleware/auth.ts`          | Route protection                |

---

## 🧠 What Is Actually Being Tested?

Even though providers are mocked:

✅ DartStream SDK provider registration
✅ Provider selection logic
✅ Frontend ↔ backend auth contract
✅ Session handling
✅ Logout behavior

This ensures **real providers will work the same way in production**.

---

## 🆘 Troubleshooting

### ❌ 400 Bad Request on login

* Ensure `provider` field is present
* Ensure dev server is running on port `8080`

### ❌ Failed to fetch

* Dart server not running
* Port mismatch
* CORS issue (ensure same machine)

---

## 📌 Final Notes for QA

* You do NOT need real provider credentials
* Try multiple providers using env vars
* Focus on auth flow consistency

If something fails, report:

* Provider name
* Request payload
* Error response

---

✅ Happy Testing with DartStream 🚀
