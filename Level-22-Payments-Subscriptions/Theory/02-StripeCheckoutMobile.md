# Stripe Checkout from Flutter

## Packages (choose path)

- Open Checkout **URL** via `url_launcher` (simplest)  
- Or `flutter_stripe` PaymentSheet (more native)  

## Sequence

```
App → POST /create-checkout { orderId } + Bearer token
Server → Stripe Checkout Session (amount from DB)
App → open session.url
User pays
Stripe → webhook → server marks paid
App → poll/refetch order
```

## Test mode

Use `pk_test` / `sk_test`. Card `4242 4242 4242 4242`.

Deep dive files: `Full-App-Tutorials/App-15-MultiVendor-Marketplace/payments/` and App 10 wallet payments notes.
