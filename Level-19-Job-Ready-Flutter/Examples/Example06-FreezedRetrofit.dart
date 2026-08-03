// Example 06: Freezed models + json_serializable + a Retrofit API client.
//
// THIS FILE NEEDS CODE GENERATION. Copy it into lib/ of a project, then run:
//
//   dart run build_runner build
//
// Until you do, your editor shows errors about the missing part files and the
// _$... functions. That is expected.
//
// pubspec.yaml:
//   dependencies:
//     dio: ^5.11.0
//     retrofit: ^4.9.2
//     json_annotation: ^4.9.0
//     freezed_annotation: ^3.1.0
//   dev_dependencies:
//     build_runner: ^2.15.1
//     freezed: ^3.2.3
//     json_serializable: ^6.11.2
//     retrofit_generator: ^10.2.8
//
// analysis_options.yaml (silences the @Default/@JsonKey warning):
//   analyzer:
//     errors:
//       invalid_annotation_target: ignore

import 'package:dio/dio.dart' hide Headers; // both packages export `Headers`
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'Example06-FreezedRetrofit.freezed.dart';
part 'Example06-FreezedRetrofit.g.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

/// Money arrives as a string like "19.99" from this API, so a converter
/// turns it into a double once, in one place.
class StringToDoubleConverter implements JsonConverter<double, String> {
  const StringToDoubleConverter();

  @override
  double fromJson(String json) => double.tryParse(json) ?? 0;

  @override
  String toJson(double object) => object.toStringAsFixed(2);
}

enum ProductStatus {
  @JsonValue('in_stock') inStock,
  @JsonValue('low_stock') lowStock,
  @JsonValue('sold_out') soldOut,
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
abstract class Product with _$Product {
  // The private constructor is what allows custom getters below.
  const Product._();

  const factory Product({
    required String id,
    required String title,
    @StringToDoubleConverter() required double price,
    required Category category,
    // Unknown values from a newer backend fall back instead of crashing.
    @JsonKey(unknownEnumValue: ProductStatus.soldOut)
    @Default(ProductStatus.inStock)
    ProductStatus status,
    @Default(<String>[]) List<String> tags,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  bool get isBuyable => status != ProductStatus.soldOut;
  String get priceLabel => '\$${price.toStringAsFixed(2)}';
}

/// The envelope every endpoint returns: {"data": ..., "message": "ok"}.
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({required this.data, required this.message});

  final T data;
  final String message;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

// ---------------------------------------------------------------------------
// A union for the outcome of a call: no boolean soup, no impossible states.
// ---------------------------------------------------------------------------

@freezed
sealed class LoadResult<T> with _$LoadResult<T> {
  const factory LoadResult.success(T value) = LoadSuccess<T>;
  const factory LoadResult.failure(String message) = LoadFailure<T>;
}

// ---------------------------------------------------------------------------
// The API: an abstract class. retrofit_generator writes the implementation.
// ---------------------------------------------------------------------------

@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class ProductApi {
  factory ProductApi(Dio dio, {String baseUrl}) = _ProductApi;

  @GET('/products')
  Future<List<Product>> getProducts({
    @Query('page') int page = 1,
    @Query('sort') String? sort,
  });

  @GET('/products/{id}')
  Future<Product> getProduct(@Path('id') String id);

  @POST('/products')
  Future<Product> create(@Body() Product product);

  @PATCH('/products/{id}')
  Future<Product> patch(
    @Path('id') String id,
    @Body() Map<String, dynamic> changes,
  );

  @DELETE('/products/{id}')
  Future<void> delete(@Path('id') String id);

  /// HttpResponse gives access to status code and headers (pagination totals).
  @GET('/products/search')
  Future<HttpResponse<List<Product>>> search(
    @Queries() Map<String, dynamic> filters,
  );
}

// ---------------------------------------------------------------------------
// Dio: policy lives here (base URL, timeouts, auth header, logging).
// ---------------------------------------------------------------------------

Dio buildDio({required Future<String?> Function() readToken}) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await readToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ),
  );

  return dio;
}

// ---------------------------------------------------------------------------
// Repository: the only place that knows DioException exists.
// ---------------------------------------------------------------------------

class ProductRepository {
  const ProductRepository(this._api);

  final ProductApi _api;

  Future<LoadResult<List<Product>>> getProducts({int page = 1}) async {
    try {
      return LoadResult.success(await _api.getProducts(page: page));
    } on DioException catch (e) {
      return LoadResult.failure(_messageFor(e));
    }
  }

  Future<LoadResult<Product>> getProduct(String id) async {
    try {
      return LoadResult.success(await _api.getProduct(id));
    } on DioException catch (e) {
      return LoadResult.failure(_messageFor(e));
    }
  }

  String _messageFor(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout =>
          'That took too long. Please try again.',
        DioExceptionType.connectionError => 'You appear to be offline.',
        DioExceptionType.cancel => 'Request cancelled.',
        DioExceptionType.badResponse when e.response?.statusCode == 401 =>
          'Please sign in again.',
        DioExceptionType.badResponse when e.response?.statusCode == 404 =>
          'We could not find that product.',
        _ => 'Something went wrong.',
      };
}

// ---------------------------------------------------------------------------
// How the pieces fit together, and how you read a union.
// ---------------------------------------------------------------------------

Future<void> demo() async {
  final dio = buildDio(readToken: () async => 'demo-token');
  final repository = ProductRepository(ProductApi(dio));

  final result = await repository.getProducts();

  // Exhaustive switch: add a third case to LoadResult and this fails to
  // compile until you handle it.
  final message = switch (result) {
    LoadSuccess(:final value) => '${value.length} products loaded',
    LoadFailure(:final message) => message,
  };

  // copyWith and value equality come free with Freezed.
  const a = Product(
    id: '1',
    title: 'Shoe',
    price: 19.99,
    category: Category(id: 'c1', name: 'Footwear'),
  );
  final b = a.copyWith(price: 24.99);

  assert(a != b);
  assert(a == a.copyWith());
  assert(b.priceLabel == '\$24.99');
  assert(message.isNotEmpty);
}
