# Contributing to DartStream

As a contributor, here are the guidelines we would like you to follow:

- [Code of Conduct](#code-of-conduct)
- [Question or Problem/Bug?](#got-a-question-or-problem)
- [Submitting an Issue](#submitting-an-issue)
- [Branching Conventions](#branching)
- [Coding Standards](#coding-standards)
- [Commit Message Guidelines](#commit-message-format)
- [Versioning Standards](#versioning-standards)
- [Submitting a Merge Request](#submitting-a-merge-request)

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Got a Question or Problem?

If you would like to chat about the question in real-time, you can reach out to related contributors via our
communication channels.

Do not open issues for general support questions as we want to keep Gitlab issues for bug reports and feature requests.

### Found a Bug?

If you find a bug in the source code, you can help by submitting an issue to our Gitlab Repository. Even better, you can
submit a Merge Request with a fix.

### Missing Feature?

You can request a new feature by submitting an issue to our Gitlab Repository. If you would like to implement a new
feature, please consider the size of the change in order to determine the right steps to proceed:

- For a Major Feature, first open an issue and outline your proposal so that it can be discussed. This process allows us
  to better coordinate our efforts, prevent duplication of work, and help you to craft the change so that it is
  successfully accepted into the project. Note: Adding a new topic to the documentation, or significantly re-writing a
  topic, counts as a major feature.
- Small Features can be crafted and directly submitted as a Merge Request.

## Submitting an Issue

Before you submit an issue, please search the issue tracker, maybe an issue for your problem already exists, and the
discussion might inform you of workarounds readily available.

We want to fix all the issues as soon as possible, but before fixing a bug we need to reproduce and confirm it. In order
to reproduce bugs, we require that you provide a minimal reproduction. Having a minimal reproducible scenario gives us a
wealth of important information without going back and forth to you with additional questions.

A minimal reproduction allows us to quickly confirm a bug (or point out a coding problem) as well as confirm that we are
fixing the right problem.

We require a minimal reproduction to save maintainers' time and ultimately be able to fix more bugs. Often, developers
find coding problems themselves while preparing a minimal reproduction. We understand that sometimes it might be hard to
extract essential bits of code from a larger codebase, but we really need to isolate the problem before we can fix it.

Unfortunately, we are not able to investigate/fix bugs without a minimal reproduction, so if we don't hear back from
you, we are going to close an issue without information to reproduce.

## Branching

This requirement is in addition to and separate from [Commit Message Format](#commit-message-format). Before you create
your branch for merge request consider following guidelines for branching:

### Branch naming conventions

- group : required
- type/scope : optional
- detail: required
- branch name: required

```
<group>-<type/scope>-<detail>/<branch-name>
  │       │             |           │
  │       │             |           |
  |       |             |           |
  |       |             |           └─⫸ Branch name: lower-case.
  │       │             |
  |       |             |
  |       |             └─⫸ Detail: MyFeature: lower-case
  │       |
  |       |
  |       └─⫸ Type/Scope: vs-website|typo|revision|new-parent|new-child|current-parent|current-child
  │
  |
  |
  └─⫸ Group: feature|patch|hotfix|tests|docs|ci
```

### Groups

- **feature** - Feature related
- **patch** - Bug fix related
- **hotfix** - HotFix related
- **tests** - Testing related
- **docs** - Docs related
- **ci** - Devops pipeline related

### Type/Scope

In some cases, certain branch groups must contain type/scope (aka. keywords) that specifically identify what the
type/scope of change. Currently, there are:

**Packages**

- `ds-api`: DartStream api related
- `ds-authentication`: DartStream authentication related
- `ds-database`: DartStream database related
- `ds-datastreaming`: DartStream datastreaming related
- `ds-email`: DartStream email related
- `ds-featureflag`: DartStream featureflag related
- `ds-middleware`: DartStream middleware related
- `ds-security`: DartStream security related
- `ds-testing`: DartStream testing related


**Docs**

- `typo` : a simple spelling, grammar or content change
- `revision` - major rewriting and additions that needs review

**Pipeline**

- `new-parent` : a new proposed parent pipeline
- `new-child` : a new proposed child pipeline
- `current-parent` : changes on the current parent pipeline
- `current-child` : changes on a current child pipeline

### Working with branches locally

**Creating your branch:**

```shell
git checkout -b feature/myfeature development
```

**Cleaning up old remote branches:**

```shell
git remote prune origin
```

**Show all branches remote and local:**

```shell
git branch -a 
```

**Removes all local branches not on remote:**

```shell
git branch -r | egrep -v -f /dev/fd/0  <(git branch -vv | grep origin) | xargs git branch -d
```

**Retrieve the latest remotes without merging:**   
Good for ensuring old cached branches are removed from your local

```shell
git fetch -p  
```

## Coding Standards

To ensure consistency throughout the source code, keep these rules in mind as you are working:

* All features or bug fixes **must be tested** by one or more specs (unit-tests).
* Follow [Dart's Effective Guide](https://dart.dev/guides/language/effective-dart).

## Commit Message Format

We have very precise rules over how our Git commit messages must be formatted. Commit messages must
follow [conventional commits standards](https://www.conventionalcommits.org). This format leads to **easier to read
commit history** and used to generate changelog.

Each commit message consists of a **header**, a **body**, and a **footer**.

```
header
<BLANK LINE>
[optional body]
<BLANK LINE>
[optional footer(s)]
```

The `header` is mandatory and must conform to the [Commit Message Header](#commit-message-header) format.

The `body` is mandatory for all commits except for those of type "docs". When the body is present it must be at least 20
characters long and must conform to the [Commit Message Body](#commit-message-body) format.

The `footer` is optional. The [Commit Message Footer](#commit-message-footer) format describes what the footer is used
for and the structure it must have.

Any line of the commit message cannot be longer than 100 characters.

#### Commit Message Header

```
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalized. No period at the end.
  │       │
  │       └─⫸ Commit Scope: vs-website|
  │
  └─⫸ Commit Type: build|ci|docs|feat|fix|perf|refactor|test
```

The `<type>` and `<summary>` fields are mandatory, the `(<scope>)` field is optional.

##### Type

Must be one of the following:

- **feature**: A new feature.
- **fix**: A bug fix.
- **test**: Adding missing tests or correcting existing tests.
- **docs**: Documentation only changes.
- **ci**: Changes to our CI configuration files and scripts.
- **build**: Changes that affect the build system or external dependencies.
- **performance**: A code change that improves performance.
- **refactor**: A code change that neither fixes a bug nor adds a feature.


##### Scope

The scope should be the name of the npm package affected (as perceived by the person reading the changelog generated
from commit messages).

The following is the list of supported scopes:

- `vs-website`

There are currently a few exceptions to the "use package name" rule:

- `packaging`: used for changes that change the dart package layout in all of our packages, e.g. public path changes,
  pubspec.yaml, changes done to all packages etc.

- `changelog`: used for updating the release notes in CHANGELOG.md

- `dev-infra`: used for dev-infra related changes

* none/empty string: useful for `test` and `refactor` changes that are done across all packages (
  e.g. `test: add missing unit tests`) and for docs changes that are not related to a specific package (
  e.g. `docs: fix typo in tutorial`).

##### Summary

Use the summary field to provide a succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize the first letter
* no dot (.) at the end

#### Commit Message Body

Just as in the summary, use the imperative, present tense: "fix" not "fixed" nor "fixes".

Explain the motivation for the change in the commit message body. This commit message should explain _why_ you are
making the change. You can include a comparison of the previous behavior with the new behavior in order to illustrate
the impact of the change.

#### Commit Message Footer

The footer can contain information about breaking changes and is also the place to reference gitlab issues, Jira
tickets, and other PRs that this commit closes or is related to.

```
BREAKING CHANGE: <breaking change summary>
<BLANK LINE>
<breaking change description + migration instructions>
<BLANK LINE>
<BLANK LINE>
Fixes #<issue number>
```

Breaking Change section should start with the phrase "BREAKING CHANGE: " followed by a summary of the breaking change, a
blank line, and a detailed description of the breaking change that also includes migration instructions.

### Revert commits

If the commit reverts a previous commit, it should begin with `revert: `, followed by the header of the reverted commit.

The content of the commit message body should contain:

- information about the SHA of the commit being reverted in the following format: `This reverts commit <SHA>`,
- a clear description of the reason for reverting the commit message.

### Signing Commits

WoAccelerator project on Gitlab is configured to allow only commits signed by contributor.
Follow [signing commits](https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/) guide on Gitlab to
configure git.

## Versioning Standards

- "+" means it is a regular release build,
- while - would indicate a pre-release build.
- (No build number after x.y.z also indicates a release build like +)
- In Dart conventions the +1 is used when publishing a patch release where the first number in the version is 0. The
  version 1.2.1+1 is not idiomatic. Essentially there are two patterns in use depending on whether the author considers
  the package stable enough to reach 1.0.0:
- Please refer here for further details https://dart.dev/tools/pub/versioning

## Submitting a Merge Request

Before you submit your Merge Request consider the following guidelines:

1. Search Gitlab for an open or closed merge request that relates to your submission. You don't want to duplicate
   existing efforts.
2. Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add.
   Discussing the design upfront helps to ensure that we're ready to accept your work.
4. Clone the dartapps/apps/WoAcceleratordating repository.
5. In your clone repository, make your changes in a new git branch:
    ```shell
    git checkout -b patch/my-fix-branch development
    ```
6. Create your patch, including appropriate test cases.
7. Follow our [Coding Rules](#coding-standards).
8. Run the full test suite, as described in the [developer documentation](docs/DEVELOPER.md), and ensure that all tests
   pass.
9. Commit your changes using a descriptive commit message that follows
   our [commit message conventions](#commit-message-format). Adherence to these conventions is necessary because
   changelogs are automatically generated from these messages.
    ```shell
    git commit --all
    ```
   Note: the optional commit -a command line option will automatically "add" and "rm" edited files.
10. Push your branch to gitlab:
    ```shell
    git push origin patch/my-fix-branch
    ```
11. In Gitlab, send a pull request to dartapps/apps/WoAcceleratordating:development.
12. Resolve merge conflicts if there are any - Conflicts and Resolutions should be discussed with the team before overriding.  

#### Addressing review feedback

Reviewer may suggest for some changes. If asked for changes via code reviews then:

1. Make the required updates to the code.
2. Re-run the test suites to ensure tests are still passing.
3. Create a fixup commit and push to your Gitlab repository (this will update your Merge Request):
   ```shell
   git commit --all --fixup HEAD
   git push
   ```

For more info on working with fixup commits see here.

#### Updating the commit message

A reviewer might often suggest changes to a commit message (for example, to add more context for a change or adhere to
our [commit message guidelines](#commit-message-format)). In order to update the commit message of the last commit on
your branch:

1. Check out your branch:

    ```shell
    git checkout my-fix-branch
    ```

2. Amend the last commit and modify the commit message:

    ```shell
    git commit --amend
    ```

3. Push to your gitlab repository:

    ```shell
    git push --force-with-lease
    ```

> NOTE:<br />
> If you need to update the commit message of an earlier commit, you can use `git rebase` in interactive mode.
> See the [git docs](https://git-scm.com/docs/git-rebase#_interactive_mode) for more details.

#### After your merge request is merged

After your merge request is merged, you can safely delete your branch and pull the changes from the main (upstream)
repository:

* Check out the development branch:

    ```shell
    git checkout development -f
    ```

* Delete the local branch:

    ```shell
    git branch -D patch/my-fix-branch
    ```

* Update your master with the latest upstream version:

    ```shell
    git pull --ff upstream development
    ```