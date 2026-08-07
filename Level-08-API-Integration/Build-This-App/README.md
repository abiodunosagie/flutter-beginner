## How to use this folder

1. Finish this level’s Theory + Examples + Exercises first.  
2. Create a **new** project (or `dart` file for CLI levels).  
3. Work the checklist in order.  
4. Only mark the level complete when **Definition of done** is true.

# Build This App — Weather + Headlines Dual API Client

> **Level app project** (not a toy snippet). Complete this after the level theory/exercises.

**Time:** 10–14 hours  
**Why it matters:** Two endpoints, typing, errors, pull-to-refresh — interview gold.

---

## Product

You are building: **Weather + Headlines Dual API Client**

## Acceptance checklist

- [ ] Weather by city (OpenWeather or open-meteo free)
- [ ] News headlines list (NewsAPI or static fallback)
- [ ] Repository layer + DTOs
- [ ] Loading/error/empty for each section
- [ ] Pull to refresh
- [ ] API key via --dart-define

## Steps

1. Create weather_news_app; add http/dio
2. Implement WeatherRepository + NewsRepository
3. Home combines both FutureBuilders or async notifier
4. Handle socket/timeout errors with retry button
5. Write 2 unit tests for JSON parsing

## Definition of done

Airplane mode shows friendly error + retry works

## After this

Full-App App-03 Movie Browser

## Link to mega tutorials

See also [`Full-App-Tutorials/README.md`](../../Full-App-Tutorials/README.md) for larger employer-grade apps (chat, ride-hailing, delivery, marketplace, …).

---

## ShopEase note

If this level’s `Capstone/` continues the **ShopEase** multi-level shop, you may do **either**:

1. This standalone **Build-This-App**, or  
2. The ShopEase Capstone for the level  

**Recommendation:** Standalone app first (cleaner portfolio repo), ShopEase if you want one long continuous project.
