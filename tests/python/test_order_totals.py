from order_totals import calculate_order_total, summarize_items


def test_calculate_order_total_applies_membership_discount_and_tax():
    order = {
        "customer_tier": "gold",
        "region": "ES",
        "items": [
            {"sku": "BOOK-1", "quantity": 2, "unit_price": 12.5},
            {"sku": "PEN-9", "quantity": 3, "unit_price": 2.0},
        ],
    }

    result = calculate_order_total(order)

    assert result["subtotal"] == 31.0
    assert result["discount"] == 3.1
    assert result["tax"] == 5.859
    assert result["total"] == 33.759


def test_summarize_items_collects_total_quantity_and_skus():
    items = [
        {"sku": "BOOK-1", "quantity": 2, "unit_price": 12.5},
        {"sku": "PEN-9", "quantity": 3, "unit_price": 2.0},
    ]

    summary = summarize_items(items)

    assert summary == {
        "total_quantity": 5,
        "unique_skus": ["BOOK-1", "PEN-9"],
    }
