#!/usr/bin/env bash
# End-to-end check: installs Thunder from this folder, creates an app, runs
# every generator and makes sure the generated app analyzes and tests clean.
#
#   ./tool/e2e.sh            (needs Flutter in PATH and internet access)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

dart pub global activate --source path "$ROOT" >/dev/null
export PATH="$PATH:$HOME/.pub-cache/bin"

cd "$WORK"
thunder version
thunder init e2e_app --org com.thunder --no-git --no-vscode --no-github-action -y
cd e2e_app

thunder feature profile -y
thunder feature "order details" -y
thunder model --name todo --json "$ROOT/example/todo.json" -y
thunder c_api --collection "$ROOT/example/demo.postman_collection.json" -y
thunder localization --from en --to ar -y || echo "translation needs internet, skipped"

flutter analyze
flutter test
echo "✅ Thunder end-to-end check passed"
