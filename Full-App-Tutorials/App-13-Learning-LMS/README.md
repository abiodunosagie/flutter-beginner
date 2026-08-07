# App 13: Learning LMS — Full Tutorial

> Courses, lessons list, progress percent, mark complete.

**Min level:** 06–09 · **Time:** 12–18 hours  

## Features
- Course catalog  
- Course detail + syllabus  
- Lesson player screen (text/video url placeholder)  
- Progress stored locally  
- Continue learning CTA on home  

## Model
```
Course { id, title, lessons[] }
Lesson { id, title, content, durationMin }
Progress { courseId, completedLessonIds }
```

## State
Progress `ChangeNotifier`; percent = completed/total.

## Portfolio
> Lightweight LMS client with syllabus navigation and persisted learning progress.
