package com.example.order;

public final class OrderRiskRules {
    private OrderRiskRules() {
    }

    public static int calculateRiskScore(String countryCode, boolean expressShipping, double orderTotal, int previousIncidents) {
        String normalizedCountry = countryCode == null ? "ES" : countryCode.toUpperCase();
        int score = 10;

        if (!"ES".equals(normalizedCountry)) {
            score += 25;
        }

        if (expressShipping) {
            score += 15;
        }

        if (orderTotal >= 800.0) {
            score += 20;
        }

        if (previousIncidents >= 3) {
            score += 20;
        }

        return score;
    }

    public static boolean requiresManualReview(String countryCode, boolean expressShipping, double orderTotal, int previousIncidents) {
        int riskScore = calculateRiskScore(countryCode, expressShipping, orderTotal, previousIncidents);

        return riskScore >= 70;
    }

    public static String reviewLane(String countryCode, boolean expressShipping) {
        String normalizedCountry = countryCode == null ? "ES" : countryCode.toUpperCase();

        if (expressShipping) {
            return "priority";
        }

        if ("PT".equals(normalizedCountry)) {
            return "priority";
        }

        return "standard";
    }
}
