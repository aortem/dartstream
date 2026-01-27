var githubExample = '''
# Name of the workflow
name: Dart CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the "main" branch
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      - uses: actions/checkout@v3

      # Set up a specific version of Dart SDK
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: "3.10.7" # You can specify a version like '3.10.7'

      # Get Dart dependencies
      - name: Install dependencies
        run: dart pub get

      # Run static analysis to check for errors, warnings, and lints
      - name: Analyze project source
        run: dart analyze

      # Run tests
      - name: Run tests
        run: dart test

''';

var gitlabExample = '''
# Define the Docker image to use.
# You can use official Dart images or Flutter-specific ones like ghcr.io/cirruslabs/flutter.
image: dart:3.10.7

# Define stages for the pipeline
stages:
  - test
  - build

# Cache dependencies to speed up subsequent jobs
cache:
  key: "\$CI_COMMIT_REF_NAME"
  paths:
    - .pub-cache/

# Job to run static analysis
analyze:
  stage: test
  script:
    - dart analyze

# Job to run tests
unit_test:
  stage: test
  script:
    - dart pub get
    - dart test

# Job to build the application (this is a generic example)
# For a Flutter project, you would use a Flutter image and `flutter build` commands.
build_project:
  stage: build
  script:
    - dart pub get
    # Example of building a generic Dart application.
    # Replace with your actual build command, e.g., for a web app: dart compile js -o build/main.js web/main.dart
    - echo "Build step would go here."
  artifacts:
    paths:
      - build/ # Save the build output as an artifact

''';
