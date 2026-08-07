# App 03: Movie Browser (REST API) — Full Tutorial

> TMDB (or free sample API) movie list, search, detail — proves async mastery.

**Min level:** 08 · **Time:** 10–16 hours · **State:** Riverpod or Provider  

---

## Setup

1. Register [TMDB](https://www.themoviedb.org/) API key (or use jsonplaceholder-style mock if offline)  
2. Pass key via `--dart-define=TMDB_KEY=...`  
3. Packages: `http` or `dio`, `cached_network_image`

---

## Architecture

```
data/
  tmdb_api.dart
  movie_repository.dart
  dto/movie_dto.dart
domain/
  movie.dart
presentation/
  movie_list_page.dart
  movie_detail_page.dart
  movie_search_delegate.dart
```

Map DTO → domain so UI never depends on JSON keys.

---

## Features

- [ ] Popular movies pagination / infinite scroll  
- [ ] Pull to refresh  
- [ ] Search  
- [ ] Detail: poster, overview, rating  
- [ ] Loading / error / empty  
- [ ] Favorites local (shared_preferences)  

---

## Repository sketch

```dart
class MovieRepository {
  Future<List<Movie>> popular({int page = 1}) async { ... }
  Future<List<Movie>> search(String q) async { ... }
  Future<MovieDetail> detail(int id) async { ... }
}
```

Handle non-200 and decode errors with typed exceptions.

---

## UI notes

- `GridView` posters  
- Hero animation to detail (level 14 polish)  
- Debounce search 300ms  

## Portfolio line

> Flutter movie browser with repository pattern, pagination, and robust async error handling.
