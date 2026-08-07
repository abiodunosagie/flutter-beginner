# App 13: Learning LMS — Complete Tutorial

> Lightweight course app: catalog, syllabus, mark lessons complete, continue learning.

**Time:** 12–18 hours  
**Minimum level:** 06–09  

---

## 1. What you are building

- Course catalog  
- Course detail with lesson list  
- Lesson screen (text content; video URL placeholder)  
- Mark complete  
- Progress % per course  
- Home “Continue learning” card  

---

## 2. Features

- [ ] 3+ sample courses in assets  
- [ ] Lessons ordered  
- [ ] Progress persisted  
- [ ] Percent = completed / total  
- [ ] Cannot mark complete twice (idempotent)  
- [ ] Continue points to first incomplete lesson  

---

## 3. Models

```dart
class Course {
  final String id, title, description;
  final List<Lesson> lessons;
}

class Lesson {
  final String id, title, content;
  final int durationMin;
}

class ProgressStore {
  // map courseId -> set of lessonIds
}
```

---

## 4. Build order

1. Catalog + detail static  
2. Lesson page  
3. Progress provider + persist  
4. Percent indicators  
5. Continue learning  

---

## 5. Test script

1. Complete lesson 1 → percent updates  
2. Kill app → still complete  
3. Continue opens next incomplete  

---

## 6. Portfolio blurb

> LMS-style Flutter client with syllabus navigation and persisted learning progress.

## Done when

Progress survives restart and continue works.

---

## 7. Continue learning algorithm

```dart
Lesson? nextLesson(Course course, Set<String> done) {
  for (final l in course.lessons) {
    if (!done.contains(l.id)) return l;
  }
  return null; // course complete
}
```

Home card:

- If any incomplete course → show title + percent + Continue button  
- If all complete → “Browse more courses”

## 8. assets/courses.json sketch

```json
[
  {
    "id": "flutter-basics",
    "title": "Flutter Basics",
    "description": "Widgets and layout",
    "lessons": [
      {"id": "l1", "title": "Intro", "content": "...", "durationMin": 5},
      {"id": "l2", "title": "Rows & Columns", "content": "...", "durationMin": 8}
    ]
  }
]
```

## 9. Persistence key

`progress_v1` → `Map<String, List<String>>` encoded as JSON.
