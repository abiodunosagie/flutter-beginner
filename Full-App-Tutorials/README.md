# Full App Tutorials — Employer-Grade Flutter Projects

> Build **real products**, not toy counters. These tutorials are start-to-finish: product brief → architecture → features → code → testing → portfolio notes.

This hub sits **beside** the level-by-level course. Each level also has a **`Build-This-App/`** folder (from Level 05 onward) so you always ship something after theory.

---

## How to use

1. Finish the **minimum level** listed for each app (or more).
2. Create a **new Flutter project** per app (`flutter create app_name`).
3. Follow the app README step by step. Type code; do not only read.
4. Put finished apps in your GitHub portfolio with screenshots + README.

**Rule:** Prefer depth on 4–6 apps over shallow clones of 20.

---

## App catalog

| # | App | Stack focus | Min level | Employer signal |
|---|-----|-------------|-----------|-----------------|
| 01 | [Habit Tracker](App-01-Habit-Tracker/README.md) | setState → Provider | 05–06 | Local productivity |
| 02 | [Expense Tracker](App-02-Expense-Tracker-Provider/README.md) | Provider + charts | 06–07 | Fintech UI + state |
| 03 | [Movie Browser](App-03-Movie-Browser-API/README.md) | REST + Riverpod | 08 | API + async |
| 04 | [Realtime Chat](App-04-Realtime-Chat-Firebase/README.md) | Firebase Auth + Firestore streams | 11 | **Chat / realtime** |
| 05 | [Ride Hailing](App-05-Ride-Hailing-Complete/README.md) | Maps, state machine, roles | 08–12 | **Uber-like systems** |
| 06 | [Food Delivery](App-06-Food-Delivery/README.md) | Multi-role, cart, orders | 07–11 | Delivery platforms |
| 07 | [E-Commerce Full](App-07-Ecommerce-Full/README.md) | Catalog, cart, checkout | 06–11 | Shop apps |
| 08 | [Social Feed](App-08-Social-Feed/README.md) | Feed, likes, profiles | 07–11 | Social products |
| 09 | [Fitness Tracker](App-09-Fitness-Tracker/README.md) | Local DB + charts | 09–14 | Health apps |
| 10 | [Wallet / Fintech](App-10-Wallet-Fintech/README.md) | Auth, ledger UI, security | 11–16 | **Payments UX** |
| 11 | [Job Board](App-11-Job-Board/README.md) | Search, filters, apply flow | 07–08 | Marketplace listings |
| 12 | [Property Rental](App-12-Property-Rental/README.md) | Maps, detail, booking UI | 07–12 | Airbnb-like |
| 13 | [Learning LMS](App-13-Learning-LMS/README.md) | Courses, progress | 06–09 | EdTech |
| 14 | [Doctor Booking](App-14-Doctor-Booking/README.md) | Scheduling, profiles | 07–11 | Healthtech |
| 15 | [Multi-Vendor Market](App-15-MultiVendor-Marketplace/README.md) | Seller + buyer roles | 11–16 | Complex roles |

---

## Suggested build order (portfolio path)

```
Habit (01) → Expense (02) → Movies (03)
    → Chat (04) ⭐
    → Food Delivery (06) or E-Commerce (07)
    → Ride Hailing (05) ⭐⭐
    → Wallet (10) or Marketplace (15)
```

Starred apps are highest interview ROI.

---

## Also required: per-level Build-This-App

| Level | Build-This-App |
|-------|----------------|
| 05 | Business card + profile UI kit |
| 06 | **Shop cart app (Provider)** — first real multi-screen state |
| 07 | Recipe browser with nested navigation |
| 08 | Weather + news dual API client |
| 09 | Offline notes (SQLite/Hive) |
| 10 | Pick one Level-10 project and finish |
| 11 | Auth + cloud todos (Firebase) |
| 12 | Map check-in + camera journal |
| 13 | Same cart app with full tests |
| 14 | Animated onboarding + micro-interactions |
| 15 | Store listing package for your best app |
| 16 | Refactor one app to clean architecture |
| 18 | AI assistant feature module |
| 19 | Portfolio polish + README + demo script |

Open each level’s `Build-This-App/README.md`.

---

## Quality bar (every app)

- [ ] Clear README (what / why / how to run)
- [ ] Folder architecture documented
- [ ] Loading + empty + error states
- [ ] No secrets in git
- [ ] At least one automated test where level allows
- [ ] Screenshots for portfolio

---

## Start

👉 **[App 01 Habit Tracker](App-01-Habit-Tracker/README.md)** if you just finished Flutter UI  
👉 **[App 04 Realtime Chat](App-04-Realtime-Chat-Firebase/README.md)** if you finished Firebase  
👉 **[App 05 Ride Hailing](App-05-Ride-Hailing-Complete/README.md)** when ready for systems-level work  
