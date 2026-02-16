# Contributing to Aortem - DartStream Open Source

Thank you for considering contributing to the Dartstream Open SourceProject.

## Quicklinks

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [What We Are Looking For](#what-we-are-looking-for)
- [How to Contribute](#how-to-contribute)
- [Getting Started](#getting-started)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)
- [Improving Documentation](#improving-documentation)
- [Support Tiers](#support-tiers)
- [SDKs and Aortem Integration](#sdks-and-aortem-integration)
- [Available Versions](#available-versions)
- [Community](#community)

## Code of Conduct

By participating and contributing to Aortem projects, you are expected to uphold our [Code of Conduct](CODE_OF_CONDUCT.md).

## What We Are Looking For

We welcome contributions in various forms, such as:

- Bug reports and fixes
- Feature requests and implementations
- Documentation improvements
- Feedback on the SDK's performance and design

## How to Contribute

Due to the significant time required to review pull requests, we generally only accept and review pull requests from our internal community and network. However, we welcome bug reports and documentation contributions from everyone.

If you wish to join our community or officially contribute to the repository, please join our Discord community or subscribe to our mailing list.

### Submitting a Bug Report
1. Check Existing Issues: Before submitting a new bug report, please check if the issue already exists in our Gitlab Issues.

2. Create a New Issue: If the bug is not listed, create a new issue. Provide a detailed description, steps to reproduce, and any relevant screenshots or logs.

### Submitting a Documentation Report

1. Check Existing Documentation: Ensure the documentation report or suggestion is not already covered.

2. Create a New Issue: Open a new issue and select the "Documentation" template. Clearly describe the documentation improvement or error.

## Getting Started

Set up your environment by:

1. Forking and cloning the project repository.
2. Installing Dart and any required dependencies.
3. Following the setup instructions to prepare your development environment.

## Pull Request Guidelines

Ensure your pull request adheres to the following:

1. Aligns with the project's code style and best practices.
2. Passes all existing tests and any new tests related to your changes.
3. Updates or adds documentation as needed.
4. Describes the changes made and the reasoning behind them.

## Reporting Bugs

When reporting bugs, include:

- Clear and descriptive title.
- Step-by-step reproduction instructions.
- Expected and actual behavior.
- Environment details (OS, Dart version, etc.).

## Feature Requests

We encourage feature requests that enhance the SDK. Please:

- Feature Request and enhcancements can be submitted through the Freshdesk subscription console.
- Explain how it aligns with the SDK's goals.
- Discuss potential implementation and impact.

## Improving Documentation

Your contributions to improve or clarify documentation are always welcome. Whether it's typo corrections, additional examples, or clearer explanations, your help is invaluable.

## Available Versions

Aortem projects is available in two versions to cater to different needs and scales:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Pre-Release - Edge Version**: Provided as an early indication of a release when breaking changes are expect.  This release is inconsistent. Use only if you are looking to test new features.

## Licensing

All Aortem packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.

## Acknowledgments

Thanks to the Dart community for continuous support and inspiration.

We would like to extend our gratitude to all the developers and contributors who have made this Firebase Dart SDK possible and continue to support its growth.

## Development

### **Installation and Dependencies**

Install dependencies with:
```bash
dart pub get
```

We aim to minimize runtime dependencies. Please review new dependencies carefully and follow Dart's best practices when proposing additions.

### **Testing**

We use an extensive suite of automated tests to ensure quality and reliability. Contributors must include appropriate tests for new features or bug fixes. Automated Gitlab workflows will validate changes during pull requests.

#### **Testing Overview**

| **Test Type**            | **Description**                                                                                             | **Command**                     |
|--------------------------|-----------------------------------------------------------------------------------------------------------|----------------------------------|
| **Unit Tests**           | Validates individual components in isolation using mocks and fakes.                                       | `dart test`                     |
| **Integration Tests**    | Validates interactions between components and external systems like Firebase.                            | `make integration-test`         |
| **End-to-End Tests**     | Simulates real-world workflows across the system using Gherkin-based test harness.                       | `make e2e-test`                 |
| **Mutation Tests**       | Ensures robustness of test coverage by introducing controlled code mutations.                            | `dart run mutest`               |
| **Static Analysis**      | Ensures code adheres to guidelines and highlights potential bugs.                                        | `dart analyze`                  |
| **Code Coverage**        | Ensures critical paths are covered with tests, generates LCOV reports.                                  | `dart test --coverage=coverage` |

#### **Unit Tests**

Run unit tests with:
```bash
dart test
```

#### **End-to-End Tests**

Our CI pipeline executes Gherkin-based end-to-end tests. To run them locally:

1. Pull the `test-harness` git submodule:
   ```bash
   git submodule update --init --recursive
   ```
2. Execute the tests:
   ```bash
   make e2e-test
   ```

#### **Mutation Testing**

Validate the robustness of your test suite using mutation tests:
```bash
dart run mutest
```

---

Here's the updated **Branching and Commit Guidelines** section with the adjustment to use **`feat` for features** and other refinements to align with your conventions:

---

## **Branching and Commit Guidelines**

### **Branch Naming Conventions**

Follow these conventions when creating branches for pull requests:
```
<type>/<branch-name>
```

| **Branch Type** | **Purpose**                                                                                         |
|-----------------|-----------------------------------------------------------------------------------------------------|
| `feat`          | For new features under development. Example: `feat/add-auth-module`.                                |
| `fix`           | For bug fixes. Example: `fix/login-error`.                                                          |
| `hotfix`        | For urgent production fixes requiring immediate attention. Example: `hotfix/critical-db-error`.     |
| `chore`         | For maintenance tasks, such as dependency updates or refactoring. Example: `chore/update-dependencies`. |
| `release`       | For preparing release branches with versioned changes. Example: `release/v1.2.0`.                   |
| `test`          | For testing-related changes, such as adding or modifying test cases. Example: `test/add-unit-tests`.|

---

### **Examples**

| **Type**          | **Example Branch Name**            |
|-------------------|------------------------------------|
| `feat`            | `feat/add-user-auth`               |
| `fix`             | `fix/payment-gateway-bug`          |
| `hotfix`          | `hotfix/critical-db-error`         |
| `chore`           | `chore/upgrade-dependencies`       |
| `test`            | `test/add-integration-tests`       |
| `release`         | `release/v1.2.0`                   |

---

### **Commit Message Format**

We follow [Conventional Commits](https://www.conventionalcommits.org) to ensure clear and consistent commit history.  

**Commit types are aligned with branch naming conventions** to maintain consistency across the workflow.

#### **Commit Structure**

```
<type>(<scope>): <short summary>
<BLANK LINE>
[optional body]
<BLANK LINE>
[optional footer(s)]
```

| **Type**      | **Branch Equivalent**  | **Description**                                                                 |
|---------------|-------------------------|---------------------------------------------------------------------------------|
| `feat`        | `feat`                 | Adds a new feature. Example: `feat(auth): add OAuth 2.0 support`.              |
| `fix`         | `fix`                  | Fixes a bug. Example: `fix(payment): resolve rounding error`.                  |
| `hotfix`      | `hotfix`               | Urgent fixes for production. Example: `hotfix(db): resolve connection issue`.  |
| `chore`       | `chore`                | Maintenance tasks or refactoring. Example: `chore(deps): update dependencies`. |
| `test`        | `test`                 | Adds or updates tests. Example: `test(api): add integration tests`.            |
| `refactor`    | `refactor`             | Code restructuring without functional changes. Example: `refactor(ui): improve layout`. |
| `release`     | `release`              | Prepares a versioned release. Example: `release: v1.2.0`.                      |

---

#### **Best Practices**

1. **Align Commit Type with Branch Type**:
   - A branch like `feat/add-auth-module` should include commits starting with `feat:`.
   - A branch like `fix/login-error` should include commits starting with `fix:`.

2. **Use Scope (Optional)**:
   - Add a scope in parentheses to specify the module or component affected.
   - Examples: `feat(auth)`, `fix(payment)`, `test(ui)`.

3. **Write a Clear Summary**:
   - Use the imperative mood for the summary (e.g., "add", "fix", not "added" or "fixed").

4. **Add Context in the Body (Optional)**:
   - Provide additional details or reasoning for the change.

5. **Reference Issues or PRs in the Footer**:
   - Use the footer for links to related issues or PRs and to indicate breaking changes.
   - Examples:
     ```plaintext
     Fixes #123
     BREAKING CHANGE: Deprecated legacy login endpoints.
     ```

---

### **Branching Rules and Protection**

To maintain consistency and ensure stability, we enforce the following **branch protection rules**:

#### **Protected Branches**
- **Branches**: `main`, `development`, `qa`, `beta`
- **Rules**:
  - Direct **pushes** are not allowed.
  - Changes must go through a **pull request** and pass all required checks before merging.
  - At least **1 reviewer** must approve pull requests.
  - Status checks:
    - **Branch name validation** must pass.
    - **Commit message validation** must pass.
    - Relevant workflows (e.g., `main-workflow`, `qa-workflow`) must pass.

#### **Unprotected Branches**
- Feature and other short-lived branches (e.g., `feat/add-auth`, `fix/login-error`) are not protected.
- Contributors can push directly to these branches.

#### **Branch Lifecycle**
- **Feature, Fix, Hotfix, Test Branches**:
  - Created by developers for specific tasks.
  - Merged into `main`, `development`, `qa`, or `` branches through pull requests.
  - Deleted after merging.

---

### **How It Works**

1. **Contributors Create Feature Branches**:
   - Example: `feat/add-user-auth`.
   - Pushes to these branches are allowed without restrictions.

2. **Pull Requests into Protected Branches**:
   - Protected branches (`main`, `development`, `qa`, `beta`) require pull requests.
   - Pull requests trigger workflows for testing and validation.

3. **Validation on Push and Pull Requests**:
   - Branch name and commit message validations are run on all branches during pushes.
   - Protected branches also enforce workflow checks and reviews.

---

### **Examples**

| **Branch Name**               | **Commit Message**                                              |
|--------------------------------|---------------------------------------------------------------|
| `feat/add-auth-module`        | `feat(auth): add OAuth 2.0 support`                            |
| `fix/payment-bug`             | `fix(payment): resolve rounding error in total calculation`   |
| `hotfix/db-connection-issue`  | `hotfix(db): resolve connection timeout in production`        |
| `chore/update-dependencies`   | `chore(deps): upgrade Dart SDK to 3.0`                        |
| `test/add-integration-tests`  | `test(auth): add integration tests for login functionality`   |
| `refactor/improve-logging`    | `refactor(logging): standardize log format`                  |
| `release/v1.2.0`              | `release: prepare for v1.2.0`                                 |


## **Releases**

This repository uses [Release Please](https://Gitlab.com/googleapis/release-please) for automated versioning and changelogs.  

Merges into the main branch trigger a new version release if changes are detected.

For versioning standards, follow [Dart's semantic versioning](https://dart.dev/tools/pub/versioning).

Here’s your updated **Submitting a Pull Request** section with improved formatting and alignment for clarity and readability:



## **Submitting a Pull Request**

Contributing to the project is highly encouraged! Please follow these steps to submit a well-structured pull request (PR):


### **Steps to Submit a Pull Request**

1. **Create a New Branch**:
   - Use the appropriate branch naming convention:
     ```bash
     git checkout -b feat/new-feature
     ```
   - Ensure your branch is based on the latest `development` branch:
     ```bash
     git fetch origin
     git checkout development
     git rebase origin/development
     ```

2. **Implement Changes**:
   - Write clean, modular code following the project's coding standards.
   - Add appropriate unit and integration tests to ensure coverage.

3. **Run Tests Locally**:
   - Validate your changes locally to ensure they don't break existing functionality:
     ```bash
     dart analyze
     dart test
     ```

4. **Commit Your Changes**:
   - Use meaningful commit messages following the [Conventional Commits](https://www.conventionalcommits.org) format:
     ```bash
     git commit -s -m "feat(sdk): implement new feature"
     ```

---

## **What Is GPG Commit Signing?**
GPG commit signing ensures that all commits are cryptographically verified as being made by you. This adds an additional layer of authenticity and security compared to the simple `Signed-off-by` line.

---

### **How to Set Up GPG Commit Signing**

#### 1. **Generate a GPG Key**
   - If you don’t already have a GPG key, generate one:
     ```bash
     gpg --full-generate-key
     ```
   - Choose the following options:
     - Key type: **RSA and RSA**
     - Key size: **4096 bits** (recommended)
     - Key expiration: As per your security requirements
     - Enter your name and email (must match your Git email).

   - After generating the key, list your keys to get the GPG key ID:
     ```bash
     gpg --list-secret-keys --keyid-format LONG
     ```

   - Note the key ID (e.g., `ABC123DEF456`).

#### 2. **Add the GPG Key to Git**
   - Configure Git to use your GPG key:
     ```bash
     git config --global user.signingkey ABC123DEF456
     git config --global commit.gpgsign true
     ```

#### 3. **Export Your GPG Public Key**
   - Export the public key to add it to GitLab:
     ```bash
     gpg --armor --export ABC123DEF456
     ```

   - Copy the output to your clipboard.

#### 4. **Add Your GPG Key to GitLab**
   - Go to **GitLab → User Settings → GPG Keys**.
   - Paste your GPG public key and click **Add Key**.

---

### **How to Sign Commits with GPG**

#### 1. **Automatically Sign All Commits**
   - Git will sign all commits and tags automatically if you enabled `commit.gpgsign`:
     ```bash
     git config --global commit.gpgsign true
     ```

#### 2. **Sign a Specific Commit**
   - If signing is not enabled globally, you can sign individual commits with the `-S` flag:
     ```bash
     git commit -S -m "feat: add authentication module"
     ```

#### 3. **Verify Signed Commits**
   - Verify a commit locally:
     ```bash
     git log --show-signature
     ```

---

### **GPG Verification Workflow**

Once GPG commit signing is enforced:
- Commits that are not GPG-signed will be rejected when pushed to the repository.
- GitLab will display a **verified badge** for signed commits in the commit history.

---

5. **Push Your Branch**:
   - Push your changes to the remote repository:
     ```bash
     git push origin feat/new-feature
     ```

6. **Open a Pull Request**:
   - Navigate to the repository on Gitlab.
   - Open a pull request targeting the `qa` branch.
   - Provide a clear title and description summarizing your changes, including:
     - The problem your changes solve.
     - The approach you used.
     - Links to relevant issues or discussions (e.g., `Closes #123`).



### **Notes**:

- Ensure your branch passes all tests and validations before creating a PR.
- If you encounter issues during the sign-off process, check your DCO compliance or consult the contributing guidelines.

---

### **Addressing Review Feedback**

Pull requests often receive feedback. Follow these steps to address requested changes:

1. **Use Fixup Commits for Small Changes**:
   - For minor fixes or changes requested during the review:
     ```bash
     git commit --all --fixup HEAD
     git push
     ```

2. **Amend Commit Messages if Needed**:
   - Update commit messages to clarify or provide additional details:
     ```bash
     git commit --amend
     git push --force-with-lease
     ```

3. **Rebase and Squash Commits**:
   - If your branch has multiple commits and needs to be cleaned up:
     ```bash
     git rebase -i origin/qa
     git push --force-with-lease
     ```

4. **Run Tests Again**:
   - Ensure all tests pass after making changes:
     ```bash
     dart analyze
     dart test
     ```

5. **Update the Pull Request**:
   - Add a comment to the PR describing what was updated in response to the feedback.

---

### **Best Practices for Pull Requests**

- **Keep Pull Requests Small**:
  - Submit changes in manageable chunks to make reviews easier.
- **Follow Coding Standards**:
  - Adhere to the project's coding style and guidelines.
- **Document Changes**:
  - Update relevant documentation, if applicable, to reflect your changes.
- **Add Tests**:
  - Ensure new features or bug fixes are thoroughly tested.
- **Reference Issues**:
  - Use `Fixes #<issue-number>` or `Closes #<issue-number>` in the PR description to auto-close related issues.

---

### **Example Workflow**

```bash
# Create a new branch
git checkout -b feat/add-auth

# Implement changes
# ...

# Run tests
dart analyze
dart test

# Commit changes
git commit -m "feat(auth): add OAuth 2.0 authentication"

# Push changes
git push origin feat/add-auth

# Open a pull request on Gitlab
# Provide a clear description linking the related issue (e.g., Fixes #45)
```

## **Versioning Standards**

We follow Dart's [semantic versioning](https://semver.org) conventions:
- `x.y.z+1`: For patch releases during pre-1.0 development.
- `x.y.z`: For stable, production-ready versions.