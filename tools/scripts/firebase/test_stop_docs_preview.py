"""Exercise destructive-command boundaries with a fake Firebase CLI only."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).with_name("stop_docs_preview.sh")
SHELL = shutil.which("sh") or r"C:\Program Files\Git\bin\bash.exe"


class StopDocsPreviewTest(unittest.TestCase):
    def invoke(self, branch, confirmation, **extra):
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            stub = folder / "firebase"
            stub.write_text(
                '#!/bin/sh\n'
                'printf "%s\\n" "$@" > "$FIREBASE_CALL_LOG"\n'
                'while [ "$#" -gt 0 ]; do\n'
                '  if [ "$1" = "--config" ]; then cat "$2" > "$FIREBASE_CONFIG_LOG"; fi\n'
                '  shift\n'
                'done\n'
                'exit "${FAKE_FIREBASE_EXIT:-0}"\n', encoding="utf-8", newline="\n")
            stub.chmod(0o755)
            log, config = folder / "call.txt", folder / "config.json"
            env = dict(os.environ, PATH=str(folder) + os.pathsep + os.environ["PATH"],
                       CI_COMMIT_BRANCH=branch, CI_COMMIT_REF_NAME=branch,
                       CI_MERGE_REQUEST_SOURCE_BRANCH_NAME="",
                       DOCS_PREVIEW_RETIREMENT_CONFIRMED=confirmation,
                       FIREBASE_CALL_LOG=str(log), FIREBASE_CONFIG_LOG=str(config))
            env.update(extra)
            result = subprocess.run([SHELL, str(SCRIPT)], env=env, capture_output=True, text=True)
            return result, log.read_text().splitlines() if log.exists() else [], \
                json.loads(config.read_text()) if config.exists() else None

    def test_stable_tag_unknown_and_malformed_refs_never_call_firebase(self):
        for branch in ["main", "development", "qa", "live", "ds-dartstream-v0.0.11",
                       "", "fix/UPPER", "fix/a/b", "fix/a;echo-danger"]:
            with self.subTest(branch=branch):
                result, calls, _ = self.invoke(branch, branch.replace("/", "-"))
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(calls, [])

    def test_confirmation_is_required_and_exact(self):
        for confirmation in ["", "yes", "fix-different", "fix/example"]:
            result, calls, _ = self.invoke("fix/example", confirmation)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(calls, [])

    def test_full_branch_channel_and_exact_project_site_config(self):
        branch = "chore/" + "a" * 70
        result, calls, config = self.invoke(branch, branch.replace("/", "-"))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(calls[:2], ["hosting:channel:delete", branch.replace("/", "-")])
        self.assertEqual(calls[2:6], ["--project", "dartstream-open-dev", "--site", "dartstream-open-dev-docs"])
        self.assertEqual(calls[-2:], ["--force", "--non-interactive"])
        self.assertEqual(config["hosting"]["site"], "dartstream-open-dev-docs")

    def test_mr_source_takes_precedence_over_synthetic_ref(self):
        result, calls, _ = self.invoke("refs/merge-requests/233/head", "fix-example",
                                      CI_MERGE_REQUEST_SOURCE_BRANCH_NAME="fix/example")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(calls[1], "fix-example")

    def test_cli_failure_remains_failed(self):
        result, calls, _ = self.invoke("fix/example", "fix-example", FAKE_FIREBASE_EXIT="23")
        self.assertEqual(result.returncode, 23)
        self.assertEqual(calls[1], "fix-example")


if __name__ == "__main__":
    unittest.main()
