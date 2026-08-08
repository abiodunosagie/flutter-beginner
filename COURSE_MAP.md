# Flutter Course Map — What to Do and in What Order

Read this whenever you feel lost. **One path. No guessing.**

---

## Two tracks (do not mix randomly)

| Track | What it is | When to use |
|-------|------------|-------------|
| **A — Level path (required)** | Theory → Examples → Exercises → **Build-This-App** | Every level, in order |
| **B — Portfolio apps (choose)** | `Full-App-Tutorials/` deep products | After the minimum level listed on each app |
| **C — Runnable samples** | `sample-apps/` clone-and-run | Study or copy patterns into your own apps |

**ShopEase** (folder Capstones that say “ShopEase”) is an **optional continuous shop** across levels.  
**Prefer Track A Build-This-App** for clean portfolio repos. Use ShopEase only if you want one long multi-level project.

---

## Level path (required)

```
01 Dart basics
02 Control flow
03 Functions & collections
04 OOP
05 Flutter UI
06 State  →  sample-apps/shop_cart_app
07 Navigation
08 APIs
09 Local storage / forms
10 Mid course project (pick one Level-10 project)
11 Firebase
12 Platform (camera, location, notifications)
13 Testing
14 Animations
15 Deployment
16 Architecture patterns
17 Interview prep
18 AI / MCP
19 Job-ready deep dives (go_router, freezed, web notes)
20 Supabase backend          ← NEW
21 Production mobile         ← NEW (FCM, Crashlytics, App Check, flavors, CI)
22 Payments & subscriptions  ← NEW
23 Quality & performance     ← NEW (a11y, l10n, isolates, Drift)
```

---

## When to open Full-App-Tutorials

| After level | Build these |
|-------------|-------------|
| 06 | App 01 Habit, App 02 Expense |
| 07–08 | App 03 Movies, App 11 Job Board |
| 09 | App 09 Fitness, App 13 LMS |
| 11 | **App 04 Chat**, App 08 Social, App 07 Ecommerce |
| 12 | **App 05 Ride Hailing**, App 19 Map tracking lab, App 12 Property |
| 16–22 | App 10 Wallet + payments, App 15 Marketplace, App 18 Subscriptions |
| 21+ | Wire FCM into Chat; Crashlytics into any shipping app |
| Stretch | App 16 Music, 17 WebSocket, 20 WebRTC, 21 Bluetooth, 22 Short video, 23 Widgetbook |

---

## Runnable samples (`sample-apps/`)

| Folder | Matches |
|--------|---------|
| `shop_cart_app` | Level 06 cart |
| `chat_starter` | App 04 patterns (needs your Firebase config) |
| `ride_hail_starter` | App 05 trip state machine + mock matching |
| `live_prices_app` | App 17 mock ticker |
| `paywall_saas_app` | App 18 / Level 22 mock paywall |

```bash
cd sample-apps/shop_cart_app && flutter pub get && flutter run
```

---

## Definition of “course complete” (honest)

- [ ] All Build-This-App projects through Level 15 done  
- [ ] At least **3** Full-Apps finished (must include Chat **or** Ride-hail)  
- [ ] One app has tests (L13) and a store listing draft (L15)  
- [ ] Levels 20–23 read + one lab each (Supabase **or** Firebase prod, payments, CI)  
- [ ] Portfolio README with screenshots  

---

## Related docs

- [HOW_TO_LEARN.md](HOW_TO_LEARN.md)  
- [Full-App-Tutorials/README.md](Full-App-Tutorials/README.md)  
- [Full-App-Tutorials/TUTORIAL_STANDARD.md](Full-App-Tutorials/TUTORIAL_STANDARD.md)  
- [GETTING_STARTED.md](GETTING_STARTED.md)  
