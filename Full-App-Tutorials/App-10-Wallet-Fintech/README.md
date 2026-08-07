# App 10: Wallet / Fintech UI — Complete Tutorial

> Banking-style wallet: balance, transactions, transfer mock, privacy toggles. Educational — no real money.

**Time:** 18–28 hours  
**Minimum level:** 11–16  
**Important:** label the app “Demo / mock ledger” in README.

---

## 1. What you are building

- Login (Firebase or mock)  
- Home: balance card + recent transactions  
- Transaction list (credit/debit)  
- Transfer form → confirmation → receipt  
- Hide balance eye toggle  
- Optional PIN gate on open  

---

## 2. Features

- [ ] Ledger model: balance recomputed from transactions  
- [ ] Seed transactions for demo  
- [ ] Transfer creates debit for sender (single-user mock)  
- [ ] Validation: amount > 0, amount ≤ balance, note optional  
- [ ] Receipt screen with reference id  
- [ ] Hide/show balance  
- [ ] Empty states  
- [ ] Clear “not real money” banner  

---

## 3. Domain (core)

```dart
enum TxType { credit, debit }

class Tx {
  final String id;
  final TxType type;
  final double amount;
  final String title;
  final DateTime createdAt;
  final String? counterparty;
}

class Ledger {
  static double balance(List<Tx> txs) {
    double b = 0;
    for (final t in txs) {
      b += t.type == TxType.credit ? t.amount : -t.amount;
    }
    return b;
  }
}
```

Never store balance as the only source of truth in a real bank; for the demo, recompute always.

---

## 4. Transfer pipeline

```
Validate
 → Create tx id (uuid)
 → Append debit tx
 → Persist
 → Navigate receipt
```

Idempotency: disable Send button while in flight.

---

## 5. Build order

1. Static UI screens with fake data  
2. Ledger math + unit tests  
3. Provider wiring  
4. Transfer flow  
5. Persistence  
6. Security UX (hide balance, PIN optional)  
7. Firebase sync stretch  

---

## 6. Test script

1. Balance 1000 seed  
2. Transfer 100 → balance 900; history shows debit  
3. Transfer 9999 → validation error  
4. Hide balance → ••••  
5. Kill app → ledger consistent  

---

## 7. Common mistakes

- Negative balance allowed  
- Double submit creates two transfers  
- Calling it “real payments” in store text  

---

## 8. Portfolio blurb

> Fintech-style wallet UI with ledger-based balance, transfer flow, and privacy-minded UX (demo only).

## Done when

Transfer + ledger tests + cold start consistency pass.
