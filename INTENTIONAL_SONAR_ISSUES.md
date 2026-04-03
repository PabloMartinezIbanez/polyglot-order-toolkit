# SonarQube Issues Intencionales

Este repositorio incluye algunos code smells intencionales para comprobar que SonarQube los detecta y que la etapa `FixWithAI(...)` puede proponer una correccion automatica sin romper los tests.

## Python

- `src/python/order_totals.py`
  - Variable local no usada en `calculate_order_total`.
  - Retorno booleano redundante en `has_bulk_order`.
  - Ramas redundantes en `_discount_rate_for_tier`.

## JavaScript

- `src/javascript/order_validator.js`
  - Retornos booleanos redundantes en `isPriorityOrder`.
  - Uso innecesario de `else` despues de `return` en `isPriorityOrder`.
  - Logica duplicada en `shippingQueueLabel`.

## Java

- `src/java/com/example/order/OrderRiskRules.java`
  - Variable local no usada en `calculateRiskScore`.
  - Retornos booleanos redundantes en `requiresManualReview`.
  - Logica duplicada para asignar la lane de revision en `reviewLane`.

## Uso esperado en los experimentos

- Abrir un PR normal para que Jenkins ejecute `Scan`, `Quality Gate` y `Fix Issues with AI`.
- Revisar en SonarQube que los hallazgos aparezcan sobre la rama analizada.
- Validar que la rama `ai-fix/*` creada por la IA pase las tres suites de prueba antes de considerar la remediacion como aceptable.
