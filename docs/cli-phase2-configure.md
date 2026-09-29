# Configure command: Phase 2 candidate

This change implements the first command in DartStream SaaS issue #155.
Published CLI 0.0.11 still guards configure/setup/generate/discover.
This source change needs normal development, main and package-release validation
before documentation or dashboard copy advertises it as available to customers.

`dartstream configure --vendor gcp` changes only `cloud.vendor` in an existing
`dartstream.yaml`. Unspecified options, custom keys, nested settings, comments,
and disabled extension state are preserved. With no options, an existing file
is unchanged. New files receive the documented defaults.

Each explicit name/vendor/auth/database/cicd option updates its corresponding
configuration field. The positive and negative cloud-features/skip-examples
flags update the corresponding booleans. Output lists changed keys and new
values, without printing previous customer values. Configuration records a
selection; it does not provision cloud resources or install providers.

`--force` explicitly replaces the entire file using defaults and passed options.
Malformed files and non-map sections otherwise fail without writing. A temporary
file and same-filesystem rename prevent partial output; ordinary concurrent
changes are detected before replacement. Nonregular files are rejected.

Setup, generate and discover remain guarded until their behavior and all flags
are implemented and tested. No existing extension registry is modified here.
