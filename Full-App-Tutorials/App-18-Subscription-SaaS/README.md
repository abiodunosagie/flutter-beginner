# App 18: Subscription SaaS (Paywall) — Complete Tutorial

> Free vs Pro feature gate. Pattern for productivity SaaS apps.

**Time:** 14–20 hours · **Min level:** 11–22  
**IAP:** RevenueCat recommended; **mock entitlement** first

## Product

- Free: 3 notes  
- Pro: unlimited notes + export  
- Paywall screen with monthly/yearly  
- Restore purchases  

## Features

- [ ] Entitlement model `isPro`  
- [ ] Feature gate before add when limit hit  
- [ ] Paywall UI  
- [ ] Mock purchase sets isPro locally  
- [ ] Document RevenueCat swap  
- [ ] Restore button  

## Architecture

```dart
class Entitlements extends ChangeNotifier {
  bool isPro = false;
  Future<void> purchaseMock() async { isPro = true; notifyListeners(); }
  Future<void> restore() async { /* RC restore */ }
}
```

## Build order

1. Notes app free tier limit  
2. Paywall UI  
3. Mock purchase  
4. Wire RevenueCat in staging  
5. Server receipt validation note (stores validate; RC helps)  

## Test script

1. Create 3 notes OK; 4th opens paywall  
2. Purchase mock → 4th allowed  
3. Restart → entitlement persists (local or RC)  

## Portfolio blurb

> SaaS-style Flutter app with free tier limits and subscription paywall architecture.
