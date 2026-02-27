## Getting Started

```bash
cd dartstream-opensource/dartstream/backend/packages/cli/ds_cli
dart pub get
```

All commands are run from this directory as:

```bash
dart run ./bin/dartstream.dart <command> [options]
```

> **Note:** Every command auto-runs a manifest/registry sync first. You'll see `🔄 Syncing manifest and registry...` before output. Warnings here are non-blocking.

---

## CLI Commands Overview

| # | Command | Description |
|---|---------|-------------|
| 1 | `init` | Initialize a new project |
| 2 | `configure` | Configure vendor, auth, database, CI/CD |
| 3 | `setup` | Setup middleware and SaaS features |
| 4 | `discover` | Discover and register extensions |
| 5 | `generate` | Generate code from templates |
| 6 | `validate` | Validate project and extensions |
| 7 | `extensions` | List all registered extensions |
| 8 | `enable-extension` | Enable a specific extension |
| 9 | `disable-extension` | Disable a specific extension |
| 10 | `list` | List all available commands |

---

## ⚠️ Known Bug: `configure` Cannot Find Project (FIXED)

**Reported by:** Soujanya Shrestha (QA)  
**Status:** Fix provided — pending merge  
**Affected files:** `ds_configure_command.dart`, `project.dart`

**Symptom:** After running `init` from `ds_cli`, running `configure --name <project>` fails with `❌ No project found`.

**Root Cause:** Two path resolution bugs:

1. **`ds_configure_command.dart` → `_loadProjectConfig()`** only searches 1 level up (`../projects/<name>/`), but the project is 3 levels up from `ds_cli` (`../../../projects/<name>/`). It was missing a root-finding mechanism.

2. **`project.dart` → `getProjectDir()`** (shared utility used by `setup` and `generate`) splits paths using hardcoded `/`, which breaks on Windows.

**Fix summary:**
- Added `_findDartstreamRoot()` to `ds_configure_command.dart` — walks up the directory tree until it finds `packages/` (same approach `init` already uses)
- Both `_loadProjectConfig()` and `getProjectDir()` now search relative to the discovered root
- Replaced hardcoded `/` splitting in `project.dart` with cross-platform `p.join()` from the `path` package

**Workaround (before fix is merged):** `cd` into the project directory before running configure:

```bash
cd backend/projects/e2e_test
dart run ../../packages/cli/ds_cli/bin/dartstream.dart configure
```

---

## Step-by-Step Testing

---

### 1. `list` — Verify CLI Works

**Run:**

```bash
dart run ./bin/dartstream.dart list
```

**Verify:**
- Outputs `Usage: dartstream <command> [arguments]`
- Lists all 10 commands with descriptions
- Commands shown: `init`, `configure`, `enable-extension`, `disable-extension`, `setup`, `discover`, `generate`, `validate`, `extensions`, `list`

---

### 2. `init` — Create a New Project

#### Test 2a: Interactive Mode (Happy Path)

**Run:**

```bash
dart run ./bin/dartstream.dart init
```

**Enter the following when prompted:**

| Prompt | Enter |
|--------|-------|
| Project Name | `test_project` |
| Project type (1-2) | `1` (New Project) |
| Frontend framework (1-7) | `1` (Dart Web) |
| Middleware (1-3) | `2` (Shelf Middleware) |

**Verify:**
- Output shows `✅ Project "test_project" initialized successfully!`
- Project created at `backend/projects/test_project`
- These files/folders exist inside the project:
  - `pubspec.yaml` — contains `ds_shelf` dependency
  - `dartstream.yaml` — contains name, version, type, framework, middleware, created_at
  - `lib/main.dart`
  - `README.md`
  - Directories: `lib/src/core/`, `lib/src/extensions/`, `lib/src/middleware/`, `test/`, `config/`, `bin/`, `web/assets/`

#### Test 2b: Flag Mode (Non-Interactive)

```bash
dart run ./bin/dartstream.dart init --name flag_project --version stable --type new --framework flutter_web --middleware dartstream
```

**Verify:**
- No interactive prompts appear
- Project created at `backend/projects/flag_project`
- `pubspec.yaml` contains `ds_custom_middleware` dependency (not ds_shelf)
- `dartstream.yaml` has `framework: flutter_web`, `middleware: dartstream`

#### Test 2c: Name Sanitization

**Run `init` and enter these names:**

| Input | Expected Sanitized Name | Should Succeed? |
|-------|------------------------|-----------------|
| `my-cool-app` | `my_cool_app` | ✅ Yes |
| `my cool app` | `my_cool_app` | ✅ Yes |
| `123bad` | — | ❌ Error: not a valid Dart identifier |
| `@#$%` | — | ❌ Error: not a valid Dart identifier |

#### Test 2d: Duplicate Project

1. Run `init` with name `dup_test`, complete the flow
2. Run `init` again with name `dup_test`
3. When asked `Overwrite? (y/N):` enter `n`

**Verify:** "Project initialization cancelled." — original project untouched.

4. Run `init` again with `dup_test`, this time enter `y`

**Verify:** Project recreated from scratch.

#### Test 2e: All Framework Choices

Run `init` selecting each framework option 1–7:

| Choice | Maps To |
|--------|---------|
| 1 | `dart_web` |
| 2 | `flutter_web` |
| 3 | `flutter_mobile` |
| 4 | `flutter_desktop` |
| 5 | `flutter_games` |
| 6 | `vue` |
| 7 | `svelte` |

Check `dartstream.yaml` for correct `framework` value each time.

#### Test 2f: All Middleware Choices

| Choice | Maps To | Pubspec Dependency |
|--------|---------|--------------------|
| 1 | `dartstream` | `ds_custom_middleware: ^0.0.1-pre` |
| 2 | `shelf` | `ds_shelf: ^0.0.1-pre+4` |
| 3 | `custom` | `ds_custom_middleware: ^0.0.1-pre` |

#### Test 2g: Existing Project Types

1. Run `init`, choose type `2` (Existing Project)
2. Choose `a` → verify `type: existing-dartstream` in dartstream.yaml
3. Run `init`, choose type `2` > `b` > `1` (Vue.js) → verify `type: migrate-vue`

---

### 3. `configure` — Configure the Project

> **Prerequisite:** You must have run `init` first. Run `configure` from the `ds_cli` directory using `--name`.
>
> ⚠️ **If on the old code (before fix):** `cd` into the project directory first — see Known Bug section above.

#### Test 3a: No Project Exists

```bash
dart run ./bin/dartstream.dart configure --name nonexistent_project
```

**Verify:** `❌ No project found. Run "dartstream init" first.`

#### Test 3b: Happy Path — Local + Firebase + Firestore

```bash
dart run ./bin/dartstream.dart configure --name test_project
```

Answer prompts:

| Prompt | Enter |
|--------|-------|
| Authentication SDK | Pick `1` (Firebase) |
| Database | Pick `1` (Firestore) |
| Confirm setup? | `y` |
| Include example code? | `y` |

> On stable version without `--cloud-features`, vendor defaults to `local` automatically.

**Verify:**
- `config.yaml` created with `vendor: local`, `auth: firebase`, `database: firestore`
- `lib/services/auth_service.dart` generated with `DSFirebaseAuthProvider`
- `lib/services/database_service.dart` generated with `DSFirestoreProvider`
- `pubspec.yaml` updated with `ds_firebase_auth` and `ds_firestore_db` dependencies

#### Test 3c: Vendor-Auth Compatibility

| Vendor | Valid Auth Providers |
|--------|---------------------|
| GCP | firebase, google_auth, auth0, magic, stytch |
| AWS | cognito, auth0, magic, stytch |
| Azure | entraid, azure_ad, auth0 |
| Local | firebase, auth0, magic, stytch, cognito, entraid |

**Test:** Choose GCP as vendor, then pass `--auth=cognito` → should show incompatibility warning.

#### Test 3d: Vendor-Database Compatibility

| Vendor | Valid Databases |
|--------|----------------|
| GCP | firestore, postgres, mysql, mongodb, nosql |
| AWS | dynamodb, rds, postgres, mysql, mongodb |
| Azure | cosmos, sql, postgres, mysql |
| Local | firestore, postgres, mysql, mongodb, nosql |

#### Test 3e: CI/CD Generation (Cloud/Beta Only)

```bash
dart run ./bin/dartstream.dart configure --name test_project --cloud-features
```

1. Choose a cloud vendor (GCP/AWS/Azure)
2. When asked about CI/CD, say `y`
3. Choose `1` (GitHub Actions)

**Verify:** `.github/workflows/dartstream.yml` created.

4. Repeat with choice `2` (GitLab CI) → `.gitlab-ci.yml` created.

#### Test 3f: Cancel Confirmation

Go through all prompts, then at `Confirm setup? (y/n)` enter `n`.

**Verify:** "Configuration cancelled." — no config files written.

#### Test 3g: Skip Examples

```bash
dart run ./bin/dartstream.dart configure --name test_project --skip-examples
```

**Verify:** No prompt about examples, no files in `lib/services/`.

---

### 4. `setup` — Setup Middleware and SaaS Features

> **Prerequisite:** Project must be initialized AND configured (config.yaml must exist).

#### Test 4a: No Project

```bash
dart run ./bin/dartstream.dart setup --name nonexistent
```

**Verify:** `❌ Project "nonexistent" does not exist.`

#### Test 4b: Not Configured

Run setup on a project that has no `config.yaml`.

**Verify:** `❌ Project not configured. Run "dartstream configure" first.`

#### Test 4c: Basic Middleware Setup

Run setup on a configured project, choose each middleware option:

| Choice | Result in `lib/src/middleware/config.dart` |
|--------|--------------------------------------------|
| 1 (Dartstream) | `DSCustomMiddleware()` registration |
| 2 (Shelf) | `DSShelfMiddleware()` registration with shelf import |
| 3 (Custom) | Commented-out template |

#### Test 4d: SaaS Features Without License

```bash
dart run ./bin/dartstream.dart setup --name test_project --features security,ai
```

**Verify:** Warning about SaaS version required. Prompts to continue with basic setup.

#### Test 4e: SaaS Features With License

```bash
dart run ./bin/dartstream.dart setup --name test_project --saas --features security,performance,ai,gaming,analytics
```

**Verify:** All 5 features show confirmation messages.

---

### 5. `generate` — Generate Code

#### Test 5a: Missing Required Flags

```bash
dart run ./bin/dartstream.dart generate
```

**Verify:** `❌ Required: --type and --name`

#### Test 5b: Generate Model

```bash
dart run ./bin/dartstream.dart generate --type model --name User
```

**Verify:** `lib/src/models/user.dart` created with User class, fromJson, toJson, copyWith, equality.

#### Test 5c: Generate API

```bash
dart run ./bin/dartstream.dart generate --type api --name Product
```

**Verify:** `lib/src/api/product_api.dart` created with GET/POST/PUT/DELETE endpoints.

#### Test 5d: Generate Provider

```bash
dart run ./bin/dartstream.dart generate --type provider --name Payment
```

**Verify:** `lib/src/providers/ds_payment_provider.dart` created.

#### Test 5e: Generate Extension

```bash
dart run ./bin/dartstream.dart generate --type extension --name Analytics
```

**Verify:** Extension file + `manifest.yaml` created with LifecycleHook interface.

#### Test 5f: Generate Scaffold (Full CRUD)

```bash
dart run ./bin/dartstream.dart generate --type scaffold --name Order --project test_project
```

**Verify 5 files created:** model, API, service, repository, and test.

#### Test 5g: Generate Dart Client Package (OpenAPI)

Create a local spec file first (example path shown for macOS/Linux):

```bash
cat > ./openapi.json << 'EOF'
{
  "openapi": "3.0.0",
  "info": { "title": "Demo API", "version": "1.0.0" },
  "servers": [{ "url": "https://api.example.com" }],
  "paths": {
    "/health": {
      "get": {
        "operationId": "getHealth",
        "summary": "Health check endpoint"
      }
    }
  }
}
EOF
```

Then run:

```bash
dart run ./bin/dartstream.dart generate --type client --name Demo --spec ./openapi.json --output ./generated_clients
```

**Verify:**
- Package created at `./generated_clients/ds_demo_client`
- Generated files include:
  - `pubspec.yaml`
  - `lib/ds_demo_client.dart`
  - `lib/src/demo_client.dart`
  - `test/demo_client_test.dart`
- Run tests:

```bash
cd ./generated_clients/ds_demo_client
dart test
```

#### Test 5h: File Exists Without --force

1. Generate model User
2. Generate model User again

**Verify:** `❌ File exists. Use --force to overwrite.`

3. Generate with `--force` → file overwritten.

---

### 6. `validate` — Validate Project & Extensions

```bash
dart run ./bin/dartstream.dart validate --project test_project
dart run ./bin/dartstream.dart validate --level core
dart run ./bin/dartstream.dart validate --strict
dart run ./bin/dartstream.dart validate --providers
```

**Verify:** Project structure validation, extension validation by level, strict code analysis warnings, provider version listing.

---

### 7. `extensions` — List Extensions

```bash
dart run ./bin/dartstream.dart extensions
dart run ./bin/dartstream.dart extensions --level core
dart run ./bin/dartstream.dart extensions --inactive
dart run ./bin/dartstream.dart extensions --json
```

---

### 8. `enable-extension`

```bash
dart run ./bin/dartstream.dart enable-extension                          # → error: no name
dart run ./bin/dartstream.dart enable-extension ds_firebase_auth_provider # → success
dart run ./bin/dartstream.dart enable-extension nonexistent_ext           # → not found + suggestions
```

---

### 9. `disable-extension`

```bash
dart run ./bin/dartstream.dart disable-extension                    # → error: no name
dart run ./bin/dartstream.dart disable-extension <active_ext>       # → disabled
dart run ./bin/dartstream.dart disable-extension <active_ext>       # → already disabled
dart run ./bin/dartstream.dart disable-extension <core_ext>         # → error: has dependents
dart run ./bin/dartstream.dart disable-extension <core_ext> --force # → force disabled
```

---

### 10. `discover` — Discover Extensions

```bash
dart run ./bin/dartstream.dart discover
dart run ./bin/dartstream.dart discover --project test_project
dart run ./bin/dartstream.dart discover --no-register
```

---

## End-to-End Workflow

```bash
# 1. Navigate to CLI
cd dartstream-opensource/dartstream/backend/packages/cli/ds_cli

# 2. Verify CLI
dart run ./bin/dartstream.dart list

# 3. Create project
dart run ./bin/dartstream.dart init
# → Name: e2e_test, New Project, Dart Web, Shelf

# 4. Install dependencies
cd ../../../projects/e2e_test
dart pub get

# 5. Configure
cd ../../packages/cli/ds_cli
dart run ./bin/dartstream.dart configure --name e2e_test
# → Firebase, Firestore, confirm Y, examples Y

# 6. Generate scaffold
dart run ./bin/dartstream.dart generate --type scaffold --name User --project e2e_test

# 7. Validate
dart run ./bin/dartstream.dart validate --project e2e_test

# 8. Discover & list extensions
dart run ./bin/dartstream.dart discover
dart run ./bin/dartstream.dart extensions
```

**Verify:** No errors at any step.
