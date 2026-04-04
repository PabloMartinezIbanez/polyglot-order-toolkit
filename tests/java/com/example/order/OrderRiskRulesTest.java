package com.example.order;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class OrderRiskRulesTest {

    @Test
    public void shouldScoreExpressInternationalOrdersHigher() {
        int score = OrderRiskRules.calculateRiskScore("PT", true, 820.0, 4);
        assertEquals(90, score, "Express international orders should score higher.");
    }

    @Test
    public void shouldRequireManualReviewForHighRiskOrders() {
        boolean result = OrderRiskRules.requiresManualReview("US", true, 910.0, 3);
        assertTrue(result, "High risk orders should require manual review.");
    }

    @Test
    public void shouldSkipManualReviewForStableDomesticOrders() {
        boolean result = OrderRiskRules.requiresManualReview("ES", false, 120.0, 1);
        assertFalse(result, "Stable domestic orders should not require manual review.");
    }
}
