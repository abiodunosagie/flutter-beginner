# Retrofit: A Typed API Client From An Abstract Class

## The Big Idea In One Sentence

> You declare your API as an **abstract Dart class with annotations**, and `retrofit_generator` writes the whole Dio implementation, including URL building, query parameters, and JSON decoding.

---

## Before And After

```dart
// BY HAND: 20 lines per endpoint, and every one is a chance to typo a key
Future<List<Product>> getProducts(int page, String? sort) async {
  final response = await dio.get(
    '/products',
    queryParameters: {'page': page, if (sort != null) 'sort': sort},
  );
  return (response.data as List)
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

```dart
// WITH RETROFIT: the signature IS the implementation
@GET('/products')
Future<List<Product>> getProducts({
  @Query('page') int page = 1,
  @Query('sort') String? sort,
});
```

---

## Setup

```yaml
dependencies:
  retrofit: ^4.9.2
  dio: ^5.11.0
  json_annotation: ^4.9.0

dev_dependencies:
  retrofit_generator: ^10.2.8
  build_runner: ^2.15.1
  json_serializable: ^6.11.2
```

```dart
// lib/data/product_api.dart
import 'package:dio/dio.dart' hide Headers;     // see the note below
import 'package:retrofit/retrofit.dart';

import '../models/product.dart';

part 'product_api.g.dart';

@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ProductApi {
  factory ProductApi(Dio dio, {String baseUrl, ParseErrorLogger errorLogger}) =
      _ProductApi;

  @GET('/products')
  Future<List<Product>> getProducts({
    @Query('page') int page = 1,
    @Query('sort') String? sort,
  });

  @GET('/products/{id}')
  Future<Product> getProduct(@Path('id') String id);

  @POST('/products')
  Future<Product> create(@Body() Product product);

  @PUT('/products/{id}')
  Future<Product> update(@Path('id') String id, @Body() Product product);

  @PATCH('/products/{id}')
  Future<Product> patch(@Path('id') String id, @Body() Map<String, dynamic> changes);

  @DELETE('/products/{id}')
  Future<void> delete(@Path('id') String id);
}
```

```bash
dart run build_runner build
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   VERIFIED GOTCHA                                    │
│                                                      │
│   Both dio and retrofit export a class named         │
│   `Headers`. Importing both plainly gives:           │
│     "The name 'Headers' is defined in the libraries  │
│      package:dio/... and package:retrofit/..."       │
│                                                      │
│   Fix: import 'package:dio/dio.dart' hide Headers;   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## The Annotation Vocabulary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   @RestApi(baseUrl:)   the class is an API client    │
│   @GET @POST @PUT      the HTTP verb and path        │
│   @PATCH @DELETE @HEAD                               │
│                                                      │
│   @Path('id')          fills {id} in the path        │
│   @Query('page')       one query parameter           │
│   @Queries()           a whole Map of query params   │
│   @Body()              the request body (a model or  │
│                        a Map)                        │
│   @Field('email')      one form field                │
│   @FormUrlEncoded()    send as a form, not JSON      │
│   @Part(name:)         one multipart piece           │
│   @MultiPart()         file upload                   │
│   @Header('X-Token')   one header, per call          │
│   @Headers({...})      fixed headers for the method  │
│   @Extra({...})        data for your interceptors    │
│   @CancelRequest()     accept a Dio CancelToken      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Examples of the less obvious ones:

```dart
// Fixed headers plus a dynamic filter map
@Headers(<String, dynamic>{'Accept': 'application/json'})
@GET('/search')
Future<List<Product>> search(@Queries() Map<String, dynamic> filters);

// Per call auth header (usually better handled by an interceptor)
@GET('/me')
Future<User> me(@Header('Authorization') String token);

// Form login
@POST('/login')
@FormUrlEncoded()
Future<Session> login(
  @Field('email') String email,
  @Field('password') String password,
);

// File upload
@POST('/upload')
@MultiPart()
Future<void> upload(
  @Part(name: 'file') File file,
  @Part(name: 'note') String note,
);

// Cancellable request (cancel it when the user leaves the screen)
@GET('/slow')
Future<Product> slow({@CancelRequest() CancelToken? cancelToken});
```

### Getting at the raw response

When you need status codes or headers, wrap the return type:

```dart
@GET('/products')
Future<HttpResponse<List<Product>>> getProductsRaw();

// usage
final result = await api.getProductsRaw();
print(result.response.statusCode);
print(result.response.headers.value('x-total-count'));
final products = result.data;
```

---

## The Dio Layer Underneath

Retrofit generates the calls; Dio still owns configuration, retries, logging, and auth. Build Dio once, in one place.

```dart
Dio buildDio({required TokenStore tokens}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokens.read();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) async {
        // One place to handle an expired session for every endpoint
        if (e.response?.statusCode == 401) {
          final refreshed = await tokens.refresh();
          if (refreshed) {
            final clone = await dio.fetch<dynamic>(e.requestOptions);
            return handler.resolve(clone);
          }
        }
        handler.next(e);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  return dio;
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   WHY THIS SPLIT MATTERS IN AN INTERVIEW             │
│                                                      │
│   Retrofit = the SHAPE of your API (endpoints,       │
│              parameters, response types)             │
│   Dio      = the POLICY (auth, timeouts, retries,    │
│              logging, base URL per environment)      │
│                                                      │
│   Auth headers belong in an interceptor, not in      │
│   @Header on 40 methods. That answer alone shows     │
│   you have built a real client.                      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Errors

The generated code throws `DioException`. Catch it in the repository (never in the UI) and translate:

```dart
class ProductRepository {
  ProductRepository(this._api);

  final ProductApi _api;

  Future<List<Product>> getProducts({int page = 1}) async {
    try {
      return await _api.getProducts(page: page);
    } on DioException catch (e) {
      throw switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => const AppFailure.timeout(),
        DioExceptionType.connectionError => const AppFailure.noConnection(),
        DioExceptionType.cancel => const AppFailure.cancelled(),
        DioExceptionType.badResponse when e.response?.statusCode == 401 =>
          const AppFailure.unauthorised(),
        DioExceptionType.badResponse when e.response?.statusCode == 404 =>
          const AppFailure.notFound(),
        _ => const AppFailure.unknown(),
      };
    }
  }
}
```

Retrofit also accepts an optional `ParseErrorLogger`, which is called when a response arrives but fails to decode into your model. Wire it to your crash reporter and you will find out the day the backend changes a field type, instead of reading about it in reviews.

---

## Wiring It All Together

```dart
void main() {
  final tokens = TokenStore();
  final dio = buildDio(tokens: tokens);
  final api = ProductApi(dio);
  final repository = ProductRepository(api);

  runApp(
    RepositoryProvider.value(
      value: repository,
      child: const App(),
    ),
  );
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Widget  ->  Bloc  ->  Repository  ->  Retrofit API │
│                                          │           │
│                                          ▼           │
│                                        Dio           │
│                                    (interceptors)    │
│                                                      │
│   Each layer only knows the next one.                │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Testing Without A Server

Because the API is an abstract class, faking it is trivial:

```dart
class MockProductApi extends Mock implements ProductApi {}

test('repository maps a timeout to AppFailure.timeout', () async {
  final api = MockProductApi();
  when(() => api.getProducts(page: any(named: 'page'))).thenThrow(
    DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.connectionTimeout,
    ),
  );

  final repo = ProductRepository(api);

  expect(() => repo.getProducts(), throwsA(isA<TimeoutFailure>()));
});
```

For the HTTP layer itself, `DioAdapter` from `http_mock_adapter` lets you fake responses at the transport level without touching your API class.

---

## Retrofit or Hand Written?

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   RETROFIT WINS WHEN                                 │
│   • more than a handful of endpoints                 │
│   • the API is stable and REST shaped                │
│   • you want the endpoint list readable in one file  │
│                                                      │
│   HAND WRITTEN WINS WHEN                             │
│   • two or three calls total                         │
│   • responses are irregular (different shapes per    │
│     status, streaming, custom pagination headers)    │
│   • you cannot add a build step                      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • @RestApi + abstract class + factory redirect     │
│   • @Path, @Query, @Queries, @Body, @Field, @Part    │
│   • import dio hiding Headers to avoid the clash     │
│   • HttpResponse<T> when you need status or headers  │
│   • Dio interceptors own auth, retries, logging      │
│   • Repositories translate DioException to failures  │
│   • Mock the abstract API class in tests             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why does importing `dio` and `retrofit` together break, and what is the fix?

<details>
<summary>Answer</summary>
Both export a class called `Headers`, so the name is ambiguous. Import Dio with `hide Headers`.
</details>

**Q2.** Where does the auth token belong: `@Header` on every method, or somewhere else?

<details>
<summary>Answer</summary>
In a Dio request interceptor. It is added once for every call, it can refresh on 401, and the API class stays clean.
</details>

**Q3.** How do you read a response header such as `x-total-count`?

<details>
<summary>Answer</summary>
Declare the return type as `Future<HttpResponse<T>>`, then read `result.response.headers` and `result.data`.
</details>

---

## Assignment

### Problem 1: Declare the API

Write the Retrofit class for: list orders with a page and status filter, get one order by id, cancel an order with a POST to `/orders/{id}/cancel`.

### Problem 2: Fix the client

A teammate put `@Header('Authorization') String token` on all 22 methods. What do you propose and why?

### Problem 3: Handle the errors

Write the `try`/`catch` in a repository that turns a 404 into `NotFoundFailure` and a connection error into `NoConnectionFailure`.

### Problem 4: Upload

Write the Retrofit method for uploading a profile photo with a caption.

---

## Assignment Answers

### Problem 1: Declare the API

```dart
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class OrderApi {
  factory OrderApi(Dio dio, {String baseUrl}) = _OrderApi;

  @GET('/orders')
  Future<List<Order>> getOrders({
    @Query('page') int page = 1,
    @Query('status') String? status,
  });

  @GET('/orders/{id}')
  Future<Order> getOrder(@Path('id') String id);

  @POST('/orders/{id}/cancel')
  Future<Order> cancelOrder(@Path('id') String id);
}
```

### Problem 2: Fix the client

Move it to a Dio request interceptor. It removes 22 duplicated parameters, guarantees no endpoint is accidentally left unauthenticated, and gives one place to refresh the token on a 401 and retry.

### Problem 3: Handle the errors

```dart
try {
  return await _api.getOrder(id);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionError) {
    throw const AppFailure.noConnection();
  }
  if (e.response?.statusCode == 404) {
    throw const AppFailure.notFound();
  }
  throw const AppFailure.unknown();
}
```

### Problem 4: Upload

```dart
@POST('/profile/photo')
@MultiPart()
Future<void> uploadPhoto(
  @Part(name: 'photo') File photo,
  @Part(name: 'caption') String caption,
);
```

---

## Navigation

⬅️ **Previous:** [Freezed Deep Dive](05c-FreezedDeepDive.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Unit Testing](06a-UnitTesting.md)
