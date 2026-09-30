# OpenAPI client generation candidate

This is the next source-controlled Phase 2 step for DartStream #155. It is not
available in the published ds_dartstream 0.0.11 package. Release and clean-install
acceptance remain required before customer dashboard or live docs advertise it.

From this source, run:

```sh
dart run bin/dartstream.dart generate --type client --name inventory \
  --spec openapi.json --output generated_clients
```

The command writes `generated_clients/ds_inventory_client`, a Dart HTTP package
whose operation methods accept `pathParameters`, `query`, `headers` and a JSON
`body`. Supply an explicit HTTP(S) `baseUrl` when constructing
`DSInventoryClient`. Pass short-lived bearer credentials in the per-call headers.
The generated package retains HTTP statuses and bodies, so callers handle 401,
403 and application errors. Redirects are returned to the caller without
forwarding credentials. Call `close()` when finished.

Run `dart pub get` and `dart analyze` in that generated package. An OpenAPI 3
JSON document must provide unique valid Dart `operationId` names. This bounded
generator does not resolve path references, infer authentication, generate typed
schema models, validate body/query requirements, or provision a service.

Existing output and linked directories are rejected without replacing customer
files. Regenerate into a new directory and review the diff. Setup and the model,
API, provider, extension and scaffold generator types remain Coming soon and do
not write files. The unused generate `--project` option is removed; `--output`
selects the destination. This does not change the configured extensions.
