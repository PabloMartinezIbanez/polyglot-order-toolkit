#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/java/classes"
TEST_FILE="$ROOT_DIR/tests/java/com/example/order/OrderRiskRulesTest.java"
SOURCE_FILE="$ROOT_DIR/src/java/com/example/order/OrderRiskRules.java"
TEST_CLASS="com.example.order.OrderRiskRulesTest"
JUNIT_VERSION="1.10.2"
JUNIT_JAR="$ROOT_DIR/.tools/junit-platform-console-standalone-${JUNIT_VERSION}.jar"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

if grep -Eq '^import\s+org\.junit\.jupiter\.' "$TEST_FILE"; then
  mkdir -p "$(dirname "$JUNIT_JAR")"
  if [[ ! -f "$JUNIT_JAR" ]]; then
    curl -fsSL \
      -o "$JUNIT_JAR" \
      "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/${JUNIT_VERSION}/junit-platform-console-standalone-${JUNIT_VERSION}.jar"
  fi

  javac -cp "$JUNIT_JAR" -d "$BUILD_DIR" \
    "$SOURCE_FILE" \
    "$TEST_FILE"

  java -jar "$JUNIT_JAR" --class-path "$BUILD_DIR" --select-class "$TEST_CLASS"
else
  javac -d "$BUILD_DIR" \
    "$SOURCE_FILE" \
    "$TEST_FILE"

  java -cp "$BUILD_DIR" "$TEST_CLASS"
fi
