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

Run `init` 7 times (or verify in code), selecting each framework option 1–7:

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

> **Prerequisite:** You must have run `init` first. Then `cd` into the project **or** pass `--name`.

#### Test 3a: No Project Exists

```bash
dart run ./bin/dartstream.dart configure
```

(Run from a directory without `dartstream.yaml`)

**Verify:** `❌ No project found. Run "dartstream init" first.`

#### Test 3b: Happy Path — GCP + Firebase + Firestore

1. `cd` into a previously initialized project directory
2. Run:

```bash
dart run ../../packages/cli/ds_cli/bin/dartstream.dart configure
```

**Or** from ds_cli directory:

```bash
dart run ./bin/dartstream.dart configure --name test_project
```

3. Answer prompts:

| Prompt | Enter |
|--------|-------|
| Cloud vendor (1-4) | `4` (Skip / Local) |
| Authentication SDK | Pick `1` (Firebase) |
| Database | Pick `1` (Firestore) |
| Confirm setup? | `y` |
| Include example code? | `y` |

**Verify:**
- `config.yaml` created with `vendor: local`, `auth: firebase`, `database: firestore`
- `lib/services/auth_service.dart` generated (if examples enabled)
- `lib/services/database_service.dart` generated (if examples enabled)
- `pubspec.yaml` updated with `ds_firebase_auth` and `ds_firestore_db` dependencies

#### Test 3c: Vendor-Auth Compatibility

These are the valid combinations:

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

Run configure with `--cloud-features`:

```bash
dart run ./bin/dartstream.dart configure --name test_project --cloud-features
```

1. Choose a cloud vendor (GCP/AWS/Azure)
2. When asked about CI/CD, say `y`
3. Choose `1` (GitHub Actions)

**Verify:** `.github/workflows/dartstream.yml` created with dart pub get, test, and analyze steps.

4. Repeat with choice `2` (GitLab CI)

**Verify:** `.gitlab-ci.yml` created with test and build stages.

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

```bash
dart run ./bin/dartstream.dart setup --name test_project
```

(Where test_project has no `config.yaml`)

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

(Without `--saas` flag)

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

**Verify:** `lib/src/models/user.dart` created with:
- `User` class with `id`, `name`, `createdAt`, `updatedAt` fields
- `fromJson()` factory constructor
- `toJson()` method
- `copyWith()` method
- Equality operators

#### Test 5c: Generate API

```bash
dart run ./bin/dartstream.dart generate --type api --name Product
```

**Verify:** `lib/src/api/product_api.dart` created with Shelf Router and GET/POST/PUT/DELETE endpoints.

#### Test 5d: Generate Provider

```bash
dart run ./bin/dartstream.dart generate --type provider --name Payment
```

**Verify:** `lib/src/providers/ds_payment_provider.dart` created.

#### Test 5e: Generate Extension

```bash
dart run ./bin/dartstream.dart generate --type extension --name Analytics
```

**Verify:**
- Extension dart file created with `LifecycleHook` interface (onInitialize, onStart, onStop, onDestroy)
- `manifest.yaml` created alongside it

#### Test 5f: Generate Scaffold (Full CRUD)

```bash
dart run ./bin/dartstream.dart generate --type scaffold --name Order --project test_project
```

**Verify 5 files created:**

| File | Content |
|------|---------|
| `lib/src/models/order.dart` | Order model class |
| `lib/src/api/order_api.dart` | REST API endpoints |
| `lib/src/services/order_service.dart` | Business logic (getAll, getById, create, update, delete) |
| `lib/src/repositories/order_repository.dart` | Repository interface + in-memory implementation |
| `test/models/order_test.dart` | Unit tests |

#### Test 5g: File Exists Without --force

1. Run: `generate --type model --name User`
2. Run again: `generate --type model --name User`

**Verify:** `❌ File exists. Use --force to overwrite.`

3. Run: `generate --type model --name User --force`

**Verify:** File overwritten successfully.

#### Test 5h: Scaffold Without Config

```bash
dart run ./bin/dartstream.dart generate --type scaffold --name Foo --project unconfigured_project
```

**Verify:** `❌ Project not configured. Run "dartstream configure" first.`

---

### 6. `validate` — Validate Project & Extensions

#### Test 6a: Valid Project

```bash
dart run ./bin/dartstream.dart validate --project test_project
```

(On a fully configured project)

**Verify:** `✓ Project structure valid` + extension validation results.

#### Test 6b: Missing Required Files

Delete `pubspec.yaml` from a project, then validate.

**Verify:** `❌ Missing required file: pubspec.yaml`

#### Test 6c: Filter by Level

```bash
dart run ./bin/dartstream.dart validate --level core
```

**Verify:** Only core-level extensions are validated.

#### Test 6d: Strict Mode

```bash
dart run ./bin/dartstream.dart validate --strict
```

**Verify:** Additional warnings for missing documentation, error handling, and provider inheritance.

#### Test 6e: Provider Validation

```bash
dart run ./bin/dartstream.dart validate --providers
```

**Verify:** Lists all auth providers with version numbers and pre-release status.

---

### 7. `extensions` — List Extensions

#### Test 7a: Default Listing

```bash
dart run ./bin/dartstream.dart extensions
```

**Verify:** Shows Core, Extended, and Third-Party sections with name, version, ACTIVE/INACTIVE status.

#### Test 7b: Filter & Flags

```bash
dart run ./bin/dartstream.dart extensions --level core
dart run ./bin/dartstream.dart extensions --inactive
dart run ./bin/dartstream.dart extensions --json
```

**Verify:**
- `--level core` shows only core extensions
- `--inactive` includes inactive extensions
- `--json` outputs valid JSON with `extensions`, `totalCount`, `activeCount`

---

### 8. `enable-extension` — Enable an Extension

#### Test 8a: No Name Given

```bash
dart run ./bin/dartstream.dart enable-extension
```

**Verify:** `Error: Please specify the name of the extension to enable.`

#### Test 8b: Enable Valid Extension

```bash
dart run ./bin/dartstream.dart enable-extension ds_firebase_auth_provider
```

**Verify:** `Extension "ds_firebase_auth_provider" has been enabled successfully.`

#### Test 8c: Extension Not Found

```bash
dart run ./bin/dartstream.dart enable-extension nonexistent_ext
```

**Verify:** Error message + suggests similar extension names if any match.

---

### 9. `disable-extension` — Disable an Extension

#### Test 9a: No Name Given

```bash
dart run ./bin/dartstream.dart disable-extension
```

**Verify:** `Error: Please specify the name of the extension to disable.`

#### Test 9b: Disable Active Extension

```bash
dart run ./bin/dartstream.dart disable-extension <active_extension_name>
```

**Verify:** `Extension has been disabled successfully.`

#### Test 9c: Already Disabled

Disable the same extension again.

**Verify:** `Extension is already disabled.`

#### Test 9d: Core Extension With Dependents

Disable a core extension that has extended features depending on it.

**Verify:** Error listing dependent extensions. Suggests `--force`.

#### Test 9e: Force Disable

```bash
dart run ./bin/dartstream.dart disable-extension <core_ext> --force
```

**Verify:** Extension disabled despite dependents.

---

### 10. `discover` — Discover Extensions

#### Test 10a: Basic Discovery

```bash
dart run ./bin/dartstream.dart discover
```

**Verify:**
- Prints extensions directory and registry file paths
- Lists discovered extensions under Core, Extended, and Third-Party categories
- Shows total count

#### Test 10b: Discovery + Registration

```bash
dart run ./bin/dartstream.dart discover --project test_project
```

**Verify:** `auto_register.dart` generated in `test_project/lib/src/extensions/`.

#### Test 10c: Skip Registration

```bash
dart run ./bin/dartstream.dart discover --no-register
```

**Verify:** Extensions listed and validated but no registration file generated.

---

## End-to-End Workflow

Run through this full sequence to validate the complete lifecycle:

```bash
# 1. Navigate to CLI
cd dartstream-opensource/dartstream/backend/packages/cli/ds_cli

# 2. Verify CLI
dart run ./bin/dartstream.dart list

# 3. Create project
dart run ./bin/dartstream.dart init
# → Name: e2e_test, New Project, Dart Web, Shelf

# 4. Go to project
cd ../../../projects/e2e_test

# 5. Install dependencies
dart pub get

# 6. Go back to CLI and configure
cd ../../packages/cli/ds_cli
dart run ./bin/dartstream.dart configure --name e2e_test
# → Local, Firebase, Firestore, confirm Y, examples Y

# 7. Generate a scaffold
dart run ./bin/dartstream.dart generate --type scaffold --name User --project e2e_test

# 8. Validate
dart run ./bin/dartstream.dart validate --project e2e_test

# 9. Discover extensions
dart run ./bin/dartstream.dart discover

# 10. List extensions
dart run ./bin/dartstream.dart extensions
```

**Verify:** No errors at any step. All files generated correctly.

---

## Known Issue

| Issue | Detail |
|-------|--------|
| `dartstream` not on PATH | After `init`, the "Next steps" say `dartstream configure`, but this fails with `command not found`. You must use `dart run ./bin/dartstream.dart configure` from the CLI directory instead. |