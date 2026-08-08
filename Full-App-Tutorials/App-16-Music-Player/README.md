# App 16: Music / Podcast Player — Complete Tutorial

> Background audio, playlist, notification controls. Strong mobile signal.

**Time:** 16–24 hours · **Min level:** 12–14  
**Packages:** `just_audio`, `audio_service` (or `audioplayers` for simpler MVP)

## Features

- [ ] Playlist list (title, artist, duration)  
- [ ] Play / pause / seek  
- [ ] Next / previous  
- [ ] Now-playing screen  
- [ ] Background playback  
- [ ] Media notification controls  
- [ ] Sleep timer stretch  

## Architecture

```
features/player/
  player_controller.dart   # ChangeNotifier or Riverpod
  playlist_page.dart
  now_playing_page.dart
data/
  tracks_repository.dart   # asset or network URLs
```

## MVP without full audio_service

Use `just_audio` foreground first. Then wrap with `audio_service` for background.

## Sample track source

Use royalty-free URLs or local `assets/audio/demo.mp3`.

## Build order

1. List of tracks from assets JSON  
2. Play one file with just_audio  
3. Seek bar + position stream  
4. Queue next/prev  
5. Background + notification  
6. Polish animations (L14)  

## Test script

1. Start track, leave app → audio continues  
2. Notification pause works  
3. Seek to middle works  

## Common mistakes

- Not handling audio focus  
- UI position timer not disposed  
- Network URLs without HTTPS  

## Portfolio blurb

> Flutter audio player with playlist queue and background/notification controls.
