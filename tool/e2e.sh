#!/usr/bin/env bash
# End-to-end check: installs Thunder from this folder and, for every state
# management (GetX, BLoC, Cubit), creates an app, runs every generator and
# makes sure the generated app analyzes and tests clean.
#
#   ./tool/e2e.sh                 all three styles
#   ./tool/e2e.sh bloc            one style
#   OFFLINE=1 ./tool/e2e.sh       use the bundled templates (no download)
#
# Needs Flutter in PATH (and internet access unless OFFLINE=1).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
STYLES=("${@:-getx bloc cubit}")
EXTRA=()
if [[ "${OFFLINE:-}" == "1" ]]; then EXTRA+=(--offline); fi

dart pub global activate --source path "$ROOT" >/dev/null
export PATH="$PATH:$HOME/.pub-cache/bin"
thunder version

for STATE in ${STYLES[*]}; do
  echo "──────── $STATE ────────"
  cd "$WORK"
  thunder init "${STATE}_app" --org com.thunder --state "$STATE" "${EXTRA[@]}" \
    --no-git --no-vscode --no-github-action -y
  cd "${STATE}_app"
  grep -q "\"state_management\": \"$STATE\"" thunder.json

  thunder feature profile -y
  thunder feature "order details" -y
  thunder model --name task --json "$ROOT/example/todo.json" -y
  thunder c_api --collection "$ROOT/example/demo.postman_collection.json" -y
  thunder localization --from en --to ar,fr -y || echo "translation needs internet, skipped"

  flutter analyze
  flutter test
  echo "✅ $STATE passed"
done
echo "✅ Thunder end-to-end check passed"
