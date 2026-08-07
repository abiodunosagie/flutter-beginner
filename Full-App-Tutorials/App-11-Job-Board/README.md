# App 11: Job Board — Complete Tutorial

> Job listings with search, filters, save, and apply form. Strong take-home without heavy backend.

**Time:** 12–18 hours  
**Minimum level:** 07–08  

---

## 1. What you are building

- Browse jobs from JSON asset or API  
- Search title/company  
- Filters: remote only, employment type, experience level  
- Job detail  
- Save/unsave jobs (local)  
- Apply form → success screen  

---

## 2. Features

- [ ] Job list cards (title, company, location, tags)  
- [ ] Search field  
- [ ] Filter bottom sheet or chips  
- [ ] Detail page  
- [ ] Saved jobs tab  
- [ ] Apply form validation  
- [ ] Application stored locally (list)  
- [ ] Empty states for search and saved  

---

## 3. Model

```dart
class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final bool isRemote;
  final String type; // full-time, contract
  final String level; // junior, mid, senior
  final String description;
  final String? salaryRange;
}
```

Put 15–20 sample jobs in `assets/jobs.json`.

---

## 4. Filtering logic

```dart
Iterable<Job> filterJobs(List<Job> all, {String q = '', bool? remote, String? type, String? level}) {
  return all.where((j) {
    final queryOk = q.isEmpty ||
        j.title.toLowerCase().contains(q.toLowerCase()) ||
        j.company.toLowerCase().contains(q.toLowerCase());
    final remoteOk = remote != true || j.isRemote;
    final typeOk = type == null || j.type == type;
    final levelOk = level == null || j.level == level;
    return queryOk && remoteOk && typeOk && levelOk;
  });
}
```

Keep this pure function — easy to unit test.

---

## 5. Build order

1. Load JSON + list  
2. Detail navigation  
3. Search  
4. Filters  
5. Saved jobs provider  
6. Apply form + applications list  

---

## 6. Test script

1. Search “Flutter” → subset  
2. Remote only → all remote  
3. Save 2 jobs → Saved tab shows 2  
4. Apply → success; application history has entry  

---

## 7. Portfolio blurb

> Job board with faceted filters, saved jobs, and application form flow.

## Done when

Search + filter + save + apply all work offline from assets.
