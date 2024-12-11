### **README for Local Git Hooks**

#### **Introduction**
This repository provides optional local Git hooks to help developers maintain code quality and adhere to commit conventions before pushing changes to the repository. These hooks automate checks during various stages of the Git workflow, ensuring that issues are caught early in the development process.

---

### **What Are Git Hooks?**
Git hooks are scripts that Git runs automatically at specific points in your workflow. Local Git hooks can be set up in your development environment to run checks before commits, pushes, or other Git actions. These hooks are not automatically shared across the team, so developers must configure them manually.

This repository includes three hooks for development:
1. **Pre-Commit Hook (`pre-commit`)**: Validates code before committing.
2. **Commit Message Hook (`commit-msg`)**: Ensures commit messages adhere to conventions.
3. **Pre-Push Hook (`pre-push`)**: Validates the branch name before allowing a push.

---

### **Included Hooks**
#### **1. Pre-Commit Hook**
- **Location**: `./local_dev_tools/validate_commit.dart`
- **Purpose**: Validates the code (e.g., linting or formatting) before allowing the commit.
- **When It Runs**: Automatically triggered before `git commit`.
- **Usage**:
  - Ensures all code complies with the repository's coding standards.
  - Prevents committing code with syntax errors or formatting issues.

#### **2. Commit Message Hook**
- **Location**: `./local_dev_tools/validate_commit_msg.dart`
- **Purpose**: Ensures commit messages follow the repository's commit message conventions (e.g., Conventional Commits).
- **When It Runs**: Automatically triggered after you enter a commit message.
- **Usage**:
  - Validates the format of commit messages, ensuring clear and consistent commit history.
  - Prevents commits with messages that fail validation.

#### **3. Pre-Push Hook**
- **Location**: `./local_dev_tools/validate_branch.dart`
- **Purpose**: Checks branch names or other repository-specific rules before pushing changes.
- **When It Runs**: Automatically triggered before `git push`.
- **Usage**:
  - Ensures that the branch name follows naming conventions.
  - Can block pushes from unintended branches (e.g., `main` or `master`).

---

### **Setup Instructions**
To enable these hooks in your local development environment:

#### **1. Install Hooks**
Run the following command to configure the hooks:
```bash
git config core.hooksPath ./local_dev_tools/
```

This command tells Git to look for hooks in the `./local_dev_tools` directory instead of the default `.git/hooks` directory.

---

### **How Developers Can Use These Hooks**
1. **Pre-Commit Checks**:
   - When you run `git commit`, the `pre-commit` hook will validate your code.
   - If any issues are detected (e.g., linting errors), the commit will be blocked, and you’ll be prompted to fix them.

2. **Commit Message Validation**:
   - After you write a commit message, the `commit-msg` hook will check the message format.
   - If the message doesn’t adhere to the required format, the commit will be rejected with instructions for fixing it.

3. **Pre-Push Validation**:
   - When you run `git push`, the `pre-push` hook will check the branch name or other repository-specific rules.
   - If the branch name is invalid or rules are violated, the push will be blocked.

---

### **FAQs**

#### **Q: Are these hooks mandatory?**
No, these hooks are optional. However, they are recommended to maintain consistency and quality.

#### **Q: How do I disable the hooks temporarily?**
To bypass hooks during a specific operation, use the `--no-verify` flag:
```bash
git commit --no-verify
git push --no-verify
```

#### **Q: Can I customize the hooks?**
Yes, you can modify the hook scripts (`validate_commit.dart`, `validate_commit_msg.dart`, and `validate_branch.dart`) to suit your project’s needs.

---

### **Additional Notes**
- These hooks run locally on your machine and do not affect other developers.
- Hooks ensure that most issues are caught during development, saving time and effort during code reviews and CI/CD processes.

For further assistance, feel free to contact the repository maintainers. Happy coding! 🎉