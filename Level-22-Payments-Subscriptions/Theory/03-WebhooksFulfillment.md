# Webhooks & Fulfillment

## Rules

1. Verify signature (`Stripe-Signature`)  
2. Idempotent handling (event may retry)  
3. Return 2xx quickly after durable write  
4. Never fulfill on client redirect alone  

## Order states

`pending → paid → fulfilled/shipped`  
or subscription `trialing → active → past_due → canceled`
