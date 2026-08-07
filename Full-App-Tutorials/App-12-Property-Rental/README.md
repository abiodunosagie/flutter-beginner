# App 12: Property Rental (Airbnb-lite) — Complete Tutorial

> Explore stays on list/map, open detail, pick dates, see price breakdown.

**Time:** 16–24 hours  
**Minimum level:** 07–12  

---

## 1. What you are building

- Listing cards (photo, title, price/night, rating)  
- Toggle list / map  
- Map markers  
- Detail with PageView photos  
- Booking sheet: check-in, check-out, guests  
- Price breakdown: nights × price + cleaning fee  
- Wishlist heart  

---

## 2. Features

- [ ] Sample listings with lat/lng  
- [ ] List and map modes  
- [ ] Marker tap → highlight listing  
- [ ] Detail gallery  
- [ ] Date range validation (checkout after checkin)  
- [ ] Guest count ≥ 1  
- [ ] Total price calculation  
- [ ] Wishlist persistence  
- [ ] Booking confirmation mock  

---

## 3. Pricing

```dart
class BookingQuote {
  static int nights(DateTime inD, DateTime outD) => outD.difference(inD).inDays;

  static double total({
    required double pricePerNight,
    required int nights,
    double cleaningFee = 35,
  }) {
    if (nights <= 0) return 0;
    return pricePerNight * nights + cleaningFee;
  }
}
```

Unit test `nights` and `total`.

---

## 4. Build order

1. Listings JSON + list UI  
2. Detail  
3. Wishlist  
4. Booking sheet math  
5. Map mode + markers  
6. Confirmation  

---

## 5. Test script

1. Open listing → book 2 nights → total = 2*price + fee  
2. Checkout before checkin → error  
3. Wishlist survives relaunch  
4. Map shows markers  

---

## 6. Portfolio blurb

> Property rental explorer with map/list modes and booking price breakdown.

## Done when

Booking quote matches manual math; map and list both usable.

---

## 7. Sample listing JSON shape

```json
{
  "id": "p1",
  "title": "Sunny loft downtown",
  "pricePerNight": 120,
  "rating": 4.8,
  "lat": 6.5244,
  "lng": 3.3792,
  "photos": ["https://picsum.photos/seed/p1/800/600"],
  "amenities": ["Wifi", "Kitchen", "AC"],
  "maxGuests": 3
}
```

## 8. Map integration notes

1. Add `google_maps_flutter`  
2. Android/iOS API keys via local config (never commit secrets)  
3. `Set<Marker>` from listings  
4. `onTap` → set `selectedId` in provider → show bottom sheet  

If maps keys are blocked, ship **list mode first** and keep map behind a feature flag.

## 9. Booking sheet UX

```
Check-in date
Check-out date
Guests stepper
---
Nights: N
Nightly: $X
Cleaning: $35
Total: $Y
[Reserve]
```

Disable Reserve until dates valid.
