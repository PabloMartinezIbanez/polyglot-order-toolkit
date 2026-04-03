#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/java/classes"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

javac -d "$BUILD_DIR" \
  "$ROOT_DIR/src/java/com/example/order/OrderRiskRules.java" \
  "$ROOT_DIR/tests/java/com/example/order/OrderRiskRulesTest.java"

java -cp "$BUILD_DIR" com.example.order.OrderRiskRulesTest
