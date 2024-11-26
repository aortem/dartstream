## Overview

The pipelines are organized by stage:
  - setup
  - unit_tests
  - integration_tests
  - e2e_tests

## Setup:
- Setup pulls in all of the dependencies for dart to properly perform unit, integration, and e2e testing
- Before making changes to any of the other pipelines, this file should be tested and checked.

## Unit Test:
- Covers the unit testing for each feature and function in the SDK.

## Integration:
- Covers group features and functions that work together to ensure seamless unit interoperatbility. 

## E2E:
- Covers each component above, both unit testing and integration testing and runs through the entire lifecycle of an application as a real end user might utilize the app.