function normalizeEmail(customerEmail) {
  return String(customerEmail || '').trim().toLowerCase();
}

function normalizeShippingMethod(shippingMethod) {
  return String(shippingMethod || 'standard').trim().toLowerCase();
}

function normalizeOrder(order) {
  return {
    customerEmail: normalizeEmail(order.customerEmail),
    shippingMethod: normalizeShippingMethod(order.shippingMethod),
    items: Array.isArray(order.items)
      ? order.items.map((item) => ({
          sku: item.sku,
          quantity: item.quantity,
        }))
      : [],
  };
}

function validateOrder(order) {
  const normalized = normalizeOrder(order);
  const errors = [];

  normalized.items.forEach((item, index) => {
    if (!item.sku || String(item.sku).trim() === '') {
      errors.push(`Item at index ${index} must include a sku.`);
    }

    if (Number(item.quantity) <= 0) {
      errors.push(`Item at index ${index} must have quantity greater than zero.`);
    }
  });

  return errors;
}

function isPriorityOrder(order) {
  const shippingMethod = normalizeShippingMethod(order.shippingMethod);
  const totalAmount = Number(order.totalAmount || 0);

  if (shippingMethod === 'express') {
    return totalAmount >= 150;
  } else {
    return false;
  }
}

function shippingQueueLabel(order) {
  const shippingMethod = normalizeShippingMethod(order.shippingMethod);

  if (shippingMethod === 'express') {
    return 'priority';
  }

  if (shippingMethod === 'same-day') {
    return 'priority';
  }

  return 'standard';
}

module.exports = {
  isPriorityOrder,
  normalizeOrder,
  shippingQueueLabel,
  validateOrder,
};
