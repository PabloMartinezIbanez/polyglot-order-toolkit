#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/java/classes"
LIB_DIR="$ROOT_DIR/lib"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$LIB_DIR"

if [ ! -f "$LIB_DIR/junit-4.13.2.jar" ]; then
  curl -sL https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar -o "$LIB_DIR/junit-4.13.2.jar"
fi
if [ ! -f "$LIB_DIR/hamcrest-core-1.3.jar" ]; then
  curl -sL https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar -o "$LIB_DIR/hamcrest-core-1.3.jar"
fi

CP="$BUILD_DIR:$LIB_DIR/junit-4.13.2.jar:$LIB_DIR/hamcrest-core-1.3.jar"

javac -cp "$CP" -d "$BUILD_DIR" \
  "$ROOT_DIR/src/java/com/example/order/OrderRiskRules.java" \
  "$ROOT_DIR/tests/java/com/example/order/OrderRiskRulesTest.java"

java -cp "$CP" org.junit.runner.JUnitCore com.example.order.OrderRiskRulesTest
