# Localization (l10n)

## Flutter gen-l10n

1. `flutter: generate: true` in pubspec  
2. `l10n.yaml`  
3. `lib/l10n/app_en.arb`, `app_es.arb`  
4. `AppLocalizations.of(context)!.hello`  

## Rules

- No user-facing hardcoded strings in UI widgets long-term  
- Format dates/numbers with `intl`  
- Plan RTL (Arabic/Hebrew) with `Directionality`  

## Practice

Localize ShopCart strings: Add, Cart, Total, Empty cart.
