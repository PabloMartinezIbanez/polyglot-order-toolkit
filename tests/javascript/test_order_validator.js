const test = require('node:test');
const assert = require('node:assert/strict');

const {
  validateOrder,
  normalizeOrder,
  isPriorityOrder,
} = require('../../src/javascript/order_validator.js');

test('normalizeOrder trims customer email and shipping method', () => {
  const normalized = normalizeOrder({
    customerEmail: '  Buyer@example.com ',
    shippingMethod: ' EXPRESS ',
    items: [{ sku: 'BOOK-1', quantity: 2 }],
  });

  assert.deepEqual(normalized, {
    customerEmail: 'buyer@example.com',
    shippingMethod: 'express',
    items: [{ sku: 'BOOK-1', quantity: 2 }],
  });
});

test('validateOrder reports missing required fields', () => {
  const errors = validateOrder({
    customerEmail: 'buyer@example.com',
    shippingMethod: 'standard',
    items: [{ sku: '', quantity: 0 }],
  });

  assert.deepEqual(errors, [
    'Item at index 0 must include a sku.',
    'Item at index 0 must have quantity greater than zero.',
  ]);
});

test('isPriorityOrder returns true for large express orders', () => {
  const result = isPriorityOrder({
    shippingMethod: 'express',
    totalAmount: 180,
  });

  assert.equal(result, true);
});
