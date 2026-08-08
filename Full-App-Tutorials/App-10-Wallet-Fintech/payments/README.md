# Wallet + Payments Notes

Wallet app remains a **demo ledger**. To add real rails:

1. Top-up → Stripe Checkout for a `pending_topup`  
2. Webhook credits ledger **server-side**  
3. Transfers between users = two ledger rows in a DB transaction  

Never invent balance only on device for real money.
