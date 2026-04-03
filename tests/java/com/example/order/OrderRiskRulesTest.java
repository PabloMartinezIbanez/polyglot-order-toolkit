package com.example.order;

public class OrderRiskRulesTest {
    public static void main(String[] args) {
        shouldScoreExpressInternationalOrdersHigher();
        shouldRequireManualReviewForHighRiskOrders();
        shouldSkipManualReviewForStableDomesticOrders();
    }

    private static void shouldScoreExpressInternationalOrdersHigher() {
        int score = OrderRiskRules.calculateRiskScore("PT", true, 820.0, 4);
        assertEquals(90, score, "Express international orders should score higher.");
    }

    private static void shouldRequireManualReviewForHighRiskOrders() {
        boolean result = OrderRiskRules.requiresManualReview("US", true, 910.0, 3);
        assertTrue(result, "High risk orders should require manual review.");
    }

    private static void shouldSkipManualReviewForStableDomesticOrders() {
        boolean result = OrderRiskRules.requiresManualReview("ES", false, 120.0, 1);
        assertFalse(result, "Stable domestic orders should not require manual review.");
    }

    private static void assertEquals(int expected, int actual, String message) {
        if (expected != actual) {
            throw new AssertionError(message + " Expected " + expected + " but got " + actual + ".");
        }
    }

    private static void assertTrue(boolean value, String message) {
        if (!value) {
            throw new AssertionError(message);
        }
    }

    private static void assertFalse(boolean value, String message) {
        if (value) {
            throw new AssertionError(message);
        }
    }
}
