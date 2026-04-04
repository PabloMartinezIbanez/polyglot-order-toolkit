#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/java/classes"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

JUNIT_JAR="$ROOT_DIR/build/junit-platform-console-standalone.jar"
if [ ! -f "$JUNIT_JAR" ]; then
  curl -sL -o "$JUNIT_JAR" "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.9.3/junit-platform-console-standalone-1.9.3.jar"
fi

javac -cp "$JUNIT_JAR" -d "$BUILD_DIR" \
  "$ROOT_DIR/src/java/com/example/order/OrderRiskRules.java" \
  "$ROOT_DIR/tests/java/com/example/order/OrderRiskRulesTest.java"

java -jar "$JUNIT_JAR" -cp "$BUILD_DIR" --scan-class-path
