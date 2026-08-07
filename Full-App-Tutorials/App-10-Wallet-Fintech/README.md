# App 10: Wallet / Fintech UI — Full Tutorial

> Mobile banking style: balance, transactions, transfer mock, PIN lock.

**Min level:** 11–16 · **Time:** 18–28 hours  
**Warning:** Educational mock — not real money movement.

## Features
- Auth + optional local PIN/biometrics UI  
- Account balance card  
- Transaction list (credit/debit)  
- Transfer form with confirmation  
- Receipt screen  
- Freeze card toggle  

## Architecture
```
domain/ledger.dart          # pure balance math
data/transaction_repository.dart
features/home|transfer|history|security
```

## Ledger rules
- Never trust client final balance alone in real systems  
- For mock: recompute from transaction list  
- Idempotent transfer ids  

## Security UX
- Obscure balance option  
- Session timeout stretch  
- No secrets in logs  

## Portfolio
> Fintech-style wallet UI with ledger model, transfer flow, and security-minded UX.
