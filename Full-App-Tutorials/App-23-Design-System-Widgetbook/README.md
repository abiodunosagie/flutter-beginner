# App 23: Design System + Widgetbook — Complete Tutorial

> Component gallery for a real design system. Team-scale Flutter.

**Time:** 10–16 hours · **Min level:** 05–16  
**Package:** `widgetbook` (or a custom Component Gallery page)

## Features

- [ ] `AppTheme` (colors, text, radius)  
- [ ] Buttons (primary/secondary/destructive)  
- [ ] Text fields  
- [ ] Cards / list tiles  
- [ ] Empty state component  
- [ ] Widgetbook (or in-app gallery) browsing widgets + knobs  

## Structure

```
packages/app_ui/   # or lib/design_system/
  theme/
  widgets/
apps/widgetbook_app/
```

Monorepo optional; single app folder is fine for learning.

## Build order

1. Extract theme from ShopCart  
2. Build AppButton  
3. Gallery list of components  
4. Add Widgetbook  
5. Document usage in README  

## Portfolio blurb

> Shared Flutter design system with documented components and Widgetbook gallery.

## Theme tokens

```dart
class AppColors {
  static const brand = Color(0xFF0F766E);
  static const danger = Color(0xFFB91C1C);
}
class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
}
```

## AppButton API

```dart
enum AppButtonVariant { primary, secondary, danger }
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  // loading?: bool
}
```

## Widgetbook use cases

- Primary / disabled / loading  
- Text field error state  
- Empty state with action  

## Done when

ShopCart (or any app) imports shared buttons/theme from the design system folder.
