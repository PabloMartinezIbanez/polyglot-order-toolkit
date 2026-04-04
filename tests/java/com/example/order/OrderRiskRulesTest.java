package com.example.order;

import org.junit.Test;
import static org.junit.Assert.*;

public class OrderRiskRulesTest {

    @Test
    public void shouldScoreExpressInternationalOrdersHigher() {
        int score = OrderRiskRules.calculateRiskScore("PT", true, 820.0, 4);
        assertEquals("Express international orders should score higher.", 90, score);
    }

    @Test
    public void shouldRequireManualReviewForHighRiskOrders() {
        boolean result = OrderRiskRules.requiresManualReview("US", true, 910.0, 3);
        assertTrue("High risk orders should require manual review.", result);
    }

    @Test
    public void shouldSkipManualReviewForStableDomesticOrders() {
        boolean result = OrderRiskRules.requiresManualReview("ES", false, 120.0, 1);
        assertFalse("Stable domestic orders should not require manual review.", result);
    }
}
