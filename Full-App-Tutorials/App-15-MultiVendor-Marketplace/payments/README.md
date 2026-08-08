# Marketplace Payments (Stripe)

## Order states

`pending → paid → shipped → completed` (+ `cancelled`, `refunded`)

## Sequence

1. Buyer places order (stock reserved or checked)  
2. Server creates Checkout Session with **DB price**  
3. Webhook `checkout.session.completed` → `paid`  
4. Seller ships  

## Idempotency

- `idempotency_key` on order create  
- Webhook handler checks if already `paid`  

## Flutter

Open Checkout URL; on return refetch order. See Level 22.
