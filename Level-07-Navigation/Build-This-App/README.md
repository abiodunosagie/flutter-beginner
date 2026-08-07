# Build This App — Recipe Browser — Nested Navigation

> **Level app project** (not a toy snippet). Complete this after the level theory/exercises.

**Time:** 6–10 hours  
**Why it matters:** Tabs + stack + detail arguments = everyday production navigation.

---

## Product

You are building: **Recipe Browser — Nested Navigation**

## Acceptance checklist

- [ ] BottomNavigationBar or NavigationBar: Home, Search, Saved
- [ ] Recipe list → detail with ingredients
- [ ] Pass Recipe object or id via route args
- [ ] Named routes or go_router basic
- [ ] Back stack behaves correctly from detail to tab
- [ ] Deep link stretch: /recipe/:id

## Steps

1. flutter create recipe_browser
2. Define Recipe model + sample list
3. Shell with IndexedStack to preserve tab state
4. Detail page with Hero image optional
5. Saved tab reads a simple SavedRecipes notifier

## Definition of done

Switch tabs without losing list scroll (IndexedStack)

## After this

Full-App App-13 LMS or App-11 Job Board

## Link to mega tutorials

See also [`Full-App-Tutorials/README.md`](../../Full-App-Tutorials/README.md) for larger employer-grade apps (chat, ride-hailing, delivery, marketplace, …).

---

## ShopEase note

If this level’s `Capstone/` continues the **ShopEase** multi-level shop, you may do **either**:

1. This standalone **Build-This-App**, or  
2. The ShopEase Capstone for the level  

**Recommendation:** Standalone app first (cleaner portfolio repo), ShopEase if you want one long continuous project.
