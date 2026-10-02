#!/bin/sh
set -eu

# Run only after the operator has verified integration and no MR/QA dependency.
# Use the full source branch: CI_COMMIT_REF_SLUG truncates long channel names.
branch=${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME:-${CI_COMMIT_BRANCH:-${CI_COMMIT_REF_NAME:-}}}
case "$branch" in
  feat/*|fix/*|hotfix/*|chore/*|test/*|refactor/*|release/*|admin/*|docs/*) ;;
  *) echo "Refusing to retire a stable, tag, or unknown docs channel." >&2; exit 1 ;;
esac
if ! printf '%s\n' "$branch" | grep -Eq '^(feat|fix|hotfix|chore|test|refactor|release|admin|docs)/[a-z0-9_-]+$'; then
  echo "Refusing an invalid docs preview branch." >&2
  exit 1
fi
channel=$(printf '%s' "$branch" | tr '/' '-')
if [ "${DOCS_PREVIEW_RETIREMENT_CONFIRMED:-}" != "$channel" ]; then
  echo "Verify source integration and no active MR/QA dependency, then confirm this exact channel." >&2
  exit 1
fi

# Explicit project/site scope prevents the CLI default from selecting other docs.
config=$(mktemp)
trap 'rm -f "$config"' EXIT HUP INT TERM
printf '%s\n' '{"hosting":{"site":"dartstream-open-dev-docs","public":"."}}' > "$config"
firebase hosting:channel:delete "$channel" \
  --project dartstream-open-dev --site dartstream-open-dev-docs \
  --config "$config" --force --non-interactive
