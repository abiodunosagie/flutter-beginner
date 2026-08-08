# App 22: Short Video Feed — Complete Tutorial

> Vertical PageView of videos (Reels-style). Caching and lifecycle matter.

**Time:** 16–24 hours · **Min level:** 08–14  
**Package:** `video_player` (+ `chewie` optional)

## Features

- [ ] Vertical PageView.builder  
- [ ] Autoplay current page only  
- [ ] Pause neighbors  
- [ ] Like overlay  
- [ ] Loading placeholder  
- [ ] Network or asset videos  

## Lifecycle rule

```dart
// On page change:
// dispose or pause previous controller
// init + play current
```

Leaking controllers = memory death.

## Build order

1. One video_player screen  
2. PageView with 5 asset/network URLs  
3. Play only active index  
4. Like button local state  
5. Prefetch next stretch  

## Portfolio blurb

> Short-form video feed with careful player lifecycle and vertical paging.

## Controller pool strategy

Keep at most **3** controllers alive: previous, current, next.

```dart
void onPageChanged(int index) {
  disposeFarAway(index);
  ensureController(index);
  play(index);
  pause(index - 1);
  pause(index + 1);
}
```

## Sample data

```json
[
  { "id": "1", "url": "https://...", "caption": "Clip 1" },
  { "id": "2", "url": "https://...", "caption": "Clip 2" }
]
```

Use short sample MP4s; do not ship huge binaries in git.

## Analytics events (optional)

`video_view`, `video_complete`, `video_like` — no PII.
