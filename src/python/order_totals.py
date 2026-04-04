REGION_TAX_RATES = {
    "ES": 0.21,
    "PT": 0.23,
    "FR": 0.20,
}


def calculate_order_total(order):
    items = order.get("items", [])
    subtotal = round(sum(item["quantity"] * item["unit_price"] for item in items), 3)
    discount_rate = _discount_rate_for_tier(order.get("customer_tier"))
    discount = round(subtotal * discount_rate, 3)
    taxable_amount = subtotal - discount
    tax = calculate_tax(taxable_amount, order.get("region", "ES"))
    total = round(taxable_amount + tax, 3)

    return {
        "subtotal": subtotal,
        "discount": discount,
        "tax": tax,
        "total": total,
    }


def calculate_tax(amount, region):
    normalized_region = (region or "ES").upper()
    return round(amount * REGION_TAX_RATES.get(normalized_region, REGION_TAX_RATES["ES"]), 3)


def summarize_items(items):
    total_quantity = 0
    unique_skus = []

    for item in items:
        total_quantity += item["quantity"]
        if item["sku"] not in unique_skus:
            unique_skus.append(item["sku"])

    return {
        "total_quantity": total_quantity,
        "unique_skus": unique_skus,
    }


def has_bulk_order(items):
    total_quantity = summarize_items(items)["total_quantity"]
    if total_quantity >= 5:
        return True
    return False


def _discount_rate_for_tier(customer_tier):
    normalized_tier = (customer_tier or "").lower()

    if normalized_tier == "gold":
        return 0.10
    elif normalized_tier == "silver":
        return 0.05
    elif normalized_tier == "bronze":
        return 0.0
    else:
        return 0.0
