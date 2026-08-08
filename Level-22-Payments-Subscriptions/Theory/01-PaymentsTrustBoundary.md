# Payments Trust Boundary

## Never in the Flutter app

- Stripe **secret** key  
- Marking order `paid` from the client  
- Trusting client-sent price as final  

## Always on a server

- Create Checkout Session / PaymentIntent with amount from DB  
- Verify **webhook signatures**  
- Fulfill: set order paid, decrement stock, unlock entitlement  

## Client role

1. Create pending order  
2. Call backend `create-checkout` with user JWT  
3. Open returned URL / payment sheet  
4. On return, **refetch** order status (do not trust deep link alone)
