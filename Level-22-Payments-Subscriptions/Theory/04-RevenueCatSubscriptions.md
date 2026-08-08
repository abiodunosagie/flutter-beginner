# RevenueCat / Subscriptions (SaaS paywall)

For **iOS/Android IAP** (Apple/Google billing):

1. Products created in App Store Connect / Play Console  
2. RevenueCat (or native IAP) maps entitlements  
3. Flutter SDK checks `isPro`  
4. Paywall UI gates features  

## Why RevenueCat

Handles receipt validation complexity across stores.

## Flutter shape

```dart
// Conceptual
final info = await Purchases.getCustomerInfo();
final isPro = info.entitlements.active.containsKey('pro');
```

App tutorial: `Full-App-Tutorials/App-18-Subscription-SaaS/`.
