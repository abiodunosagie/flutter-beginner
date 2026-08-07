# App 03: Movie Browser (REST API) — Complete Tutorial

> Browse popular movies, search, open details. Proves async + repository skills employers test for.

**Time:** 10–16 hours  
**Minimum level:** 08  
**State:** Provider **or** Riverpod (pick one and stick to it)  
**HTTP:** `dio` recommended  

---

## 1. What you are building

A movie client that:

1. Loads a page of popular movies from the internet  
2. Shows poster grid  
3. Opens a detail screen (overview, rating, release date)  
4. Supports search  
5. Handles loading, empty, and error (with Retry)  
6. Optionally saves favorites offline  

---

## 2. API choice

**Preferred:** [TMDB](https://www.themoviedb.org/settings/api) free API key  

```bash
flutter run --dart-define=TMDB_KEY=your_key_here
```

```dart
const tmdbKey = String.fromEnvironment('TMDB_KEY');
```

**If you cannot get a key today:** use a mock JSON asset (`assets/mock_movies.json`) with the **same repository interface**, then swap to real HTTP later. Do not block learning on signup.

Base URLs (TMDB):

- Popular: `https://api.themoviedb.org/3/movie/popular?api_key=$key&page=$page`  
- Search: `https://api.themoviedb.org/3/search/movie?api_key=$key&query=$q`  
- Detail: `https://api.themoviedb.org/3/movie/$id?api_key=$key`  
- Poster: `https://image.tmdb.org/t/p/w500$posterPath`  

---

## 3. Features

- [ ] Popular movies grid  
- [ ] Pagination or “Load more”  
- [ ] Pull to refresh  
- [ ] Search page or search delegate  
- [ ] Detail page  
- [ ] Loading indicator  
- [ ] Error view + Retry  
- [ ] Repository maps DTO → domain Movie  
- [ ] API key not hard-coded in git  

**Stretch:** favorites with shared_preferences, Hero animation, infinite scroll

---

## 4. Project setup

```bash
flutter create movie_browser
cd movie_browser
flutter pub add dio provider cached_network_image
```

---

## 5. Architecture (do not skip)

```
lib/
  main.dart
  core/config.dart          # reads TMDB_KEY
  data/
    dto/movie_dto.dart
    movie_api.dart
    movie_repository.dart
  domain/movie.dart
  providers/movie_provider.dart
  pages/
    movie_list_page.dart
    movie_detail_page.dart
    movie_search_page.dart
  widgets/
    movie_card.dart
    async_body.dart         # loading/error/data switch
```

**Rule:** UI never parses JSON. Only `MovieRepository` returns `Movie` objects.

---

## 6. Domain vs DTO

```dart
// domain
class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterUrl;
  final double voteAverage;
  final String? releaseDate;
  const Movie({...});
}

// dto fields follow API: poster_path, vote_average, release_date
```

Map in repository:

```dart
Movie toDomain(MovieDto d) => Movie(
  id: d.id,
  title: d.title,
  overview: d.overview,
  posterUrl: d.posterPath == null ? null : 'https://image.tmdb.org/t/p/w500${d.posterPath}',
  voteAverage: d.voteAverage,
  releaseDate: d.releaseDate,
);
```

---

## 7. API client

```dart
class MovieApi {
  MovieApi(this._dio);
  final Dio _dio;

  Future<List<MovieDto>> popular(int page) async {
    final res = await _dio.get('/movie/popular', queryParameters: {
      'api_key': tmdbKey,
      'page': page,
    });
    final results = res.data['results'] as List;
    return results.map((e) => MovieDto.fromJson(e)).toList();
  }
}
```

Create Dio with `BaseOptions(baseUrl: 'https://api.themoviedb.org/3')`.

Catch `DioException` and throw a simple `AppException(message)`.

---

## 8. Provider state shape

```dart
enum LoadState { idle, loading, data, empty, error }

class MovieProvider extends ChangeNotifier {
  LoadState state = LoadState.idle;
  List<Movie> movies = [];
  String? error;
  int page = 1;
  bool loadingMore = false;

  Future<void> loadPopular({bool refresh = false}) async { ... }
  Future<void> loadMore() async { ... }
  Future<void> search(String q) async { ... }
}
```

---

## 9. Build order

1. **Config + Dio + one popular fetch printed in debug**  
   Done when: console prints titles  
2. **Repository + domain**  
   Done when: unit-testable map function exists  
3. **Grid UI with loading/error**  
   Done when: Retry works after airplane mode  
4. **Detail route with arguments (Movie)**  
   Done when: overview visible  
5. **Search**  
   Done when: empty query does not crash  
6. **Load more / refresh**  
   Done when: page 2 appends, not replaces  

---

## 10. UI notes

- `GridView.builder` crossAxisCount 2  
- `CachedNetworkImage` for posters  
- Debounce search 300ms (`Timer`)  
- Disable load-more button while `loadingMore`  

---

## 11. Test script

1. Launch with valid key → posters load  
2. Airplane mode → error + Retry restores  
3. Search “Matrix” → related results  
4. Open detail → overview not empty  
5. Load more → list grows  

---

## 12. Common mistakes

| Mistake | Fix |
|---------|-----|
| API key in source committed | `--dart-define` or local config gitignored |
| UI uses `Map<String,dynamic>` | Always map to `Movie` |
| No timeout | Set Dio connectTimeout |
| Catch empty `results` as error | Use empty state |

---

## 13. Portfolio blurb

> Flutter movie browser with Dio, repository pattern, pagination, and robust async error handling against a real REST API.

## Done when

All feature checkboxes pass on a cold run (not only hot reload).
