# CLI discovery candidate behavior

Source for the next Phase 2 release implements manifest discovery. The published
ds_dartstream 0.0.11 package still guards discovery as Coming soon.

`dartstream discover` validates and lists local manifests without writing an
extension registry. Pass `--register` explicitly to register new manifests;
existing enable/disable choices and customer metadata are preserved. `--project`
selects a project directory, and `--no-register` also performs inspection only.
Discovery never loads extension code. `--no-validate` is rejected rather than
bypassing validation. Release and clean-install acceptance remain required
before customer dashboard and live docs advertise this behavior.
