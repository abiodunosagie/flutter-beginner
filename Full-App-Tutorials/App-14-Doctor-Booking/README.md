# App 14: Doctor Appointment Booking — Complete Tutorial

> Healthtech booking: find doctors, pick slots, manage appointments.

**Time:** 14–22 hours  
**Minimum level:** 07–11  

---

## 1. What you are building

- Doctors list by specialty filter  
- Doctor profile  
- Available slots for next 7 days (generated mock)  
- Book slot  
- My appointments (upcoming / past)  
- Cancel if more than 12 hours away  

---

## 2. Features

- [ ] Specialties chips  
- [ ] Doctor cards  
- [ ] Slot grid (date + time)  
- [ ] Prevent double booking same slot  
- [ ] Appointment confirmation  
- [ ] Cancel rules  
- [ ] Persistence or Firebase  

---

## 3. Domain rules

```dart
bool canCancel(DateTime appointmentStart, {DateTime? now}) {
  now ??= DateTime.now();
  return appointmentStart.difference(now).inHours >= 12;
}
```

When booking:

```dart
if (takenSlots.contains(slotId)) throw StateError('Slot taken');
```

---

## 4. Build order

1. Doctors JSON + list/filter  
2. Profile  
3. Slot generator (e.g. 09:00–16:00 hourly)  
4. Booking + appointments list  
5. Cancel rule  
6. Firebase stretch  

---

## 5. Test script

1. Book Mon 10:00  
2. Same slot not available again  
3. Cancel 20h before → allowed  
4. Cancel 2h before → blocked with message  

---

## 6. Portfolio blurb

> Appointment booking app with slot availability and cancellation policy logic.

## Done when

Double-book impossible; cancel policy enforced.

---

## 7. Slot generation

```dart
List<DateTime> generateSlots({
  required DateTime day,
  int startHour = 9,
  int endHour = 16,
}) {
  final out = <DateTime>[];
  for (var h = startHour; h < endHour; h++) {
    out.add(DateTime(day.year, day.month, day.day, h));
  }
  return out;
}
```

Mark slot taken if any appointment exists with same doctorId + exact DateTime.

## 8. Appointment model

```dart
class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final DateTime start;
  final String patientName;
  final String status; // booked | cancelled
}
```

## 9. UI map

- Home: specialties + doctors  
- DoctorProfile: bio + Book button  
- SlotPage: dates horizontal, times wrap  
- MyAppointments: tabs Upcoming / Past
