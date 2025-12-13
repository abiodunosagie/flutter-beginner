/// Example 05: Data Models in Action
///
/// This example demonstrates type-safe data models with:
/// - Nested objects
/// - Nullable fields
/// - List of objects
/// - Complete fromJson/toJson
///
/// Run this file: dart run Example05-DataModels.dart

import 'dart:convert';

// ═══════════════════════════════════════════════════════════════════════════
// WHAT THIS EXAMPLE COVERS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Creating comprehensive data models
// 2. Handling nested objects
// 3. Working with nullable fields
// 4. Parsing arrays of objects
// 5. Using copyWith for immutability
//
// ═══════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════
// GEO MODEL (Nested in Address)
// ═══════════════════════════════════════════════════════════════════════════
//
// JSON:
// {
//   "lat": "-37.3159",
//   "lng": "81.1496"
// }

class Geo {
  final double lat;
  final double lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    // Handle both string and numeric values from API
    return Geo(
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat.toString(),
        'lng': lng.toString(),
      };

  /// Helper to parse double from string or number
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() => 'Geo(lat: $lat, lng: $lng)';
}

// ═══════════════════════════════════════════════════════════════════════════
// ADDRESS MODEL (Nested in User)
// ═══════════════════════════════════════════════════════════════════════════
//
// JSON:
// {
//   "street": "Kulas Light",
//   "suite": "Apt. 556",
//   "city": "Gwenborough",
//   "zipcode": "92998-3874",
//   "geo": {...}
// }

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo? geo; // Nullable nested object

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      suite: json['suite'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      // Parse nested object only if present
      geo: json['geo'] != null ? Geo.fromJson(json['geo']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'suite': suite,
        'city': city,
        'zipcode': zipcode,
        if (geo != null) 'geo': geo!.toJson(),
      };

  /// Full formatted address
  String get fullAddress => '$street, $suite, $city $zipcode';

  @override
  String toString() => 'Address($fullAddress)';
}

// ═══════════════════════════════════════════════════════════════════════════
// COMPANY MODEL (Nested in User)
// ═══════════════════════════════════════════════════════════════════════════

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catchPhrase: json['catchPhrase'] ?? '',
      bs: json['bs'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'catchPhrase': catchPhrase,
        'bs': bs,
      };

  @override
  String toString() => 'Company($name)';
}

// ═══════════════════════════════════════════════════════════════════════════
// USER MODEL (Main model with nested objects)
// ═══════════════════════════════════════════════════════════════════════════
//
// Full JSON structure:
// {
//   "id": 1,
//   "name": "Leanne Graham",
//   "username": "Bret",
//   "email": "Sincere@april.biz",
//   "address": {...},
//   "phone": "1-770-736-8031 x56442",
//   "website": "hildegard.org",
//   "company": {...}
// }

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address; // Required nested object
  final String? phone; // Nullable string
  final String? website; // Nullable string
  final Company? company; // Nullable nested object

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    this.phone,
    this.website,
    this.company,
  });

  /// Create User from JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      // Parse nested Address (required)
      address: Address.fromJson(json['address'] ?? {}),
      // Nullable fields
      phone: json['phone'],
      website: json['website'],
      // Parse nested Company (nullable)
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
    );
  }

  /// Convert User to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address.toJson(),
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (company != null) 'company': company!.toJson(),
    };
  }

  /// Create a copy with some fields modified
  User copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    Address? address,
    String? phone,
    String? website,
    Company? company,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      company: company ?? this.company,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name)';

  /// Formatted display string
  String get displayInfo => '''
User #$id: $name
  Username: $username
  Email: $email
  Phone: ${phone ?? 'N/A'}
  Website: ${website ?? 'N/A'}
  Address: ${address.fullAddress}
  Company: ${company?.name ?? 'N/A'}''';
}

// ═══════════════════════════════════════════════════════════════════════════
// API RESPONSE WRAPPER
// ═══════════════════════════════════════════════════════════════════════════
//
// Many APIs wrap data like:
// {
//   "status": "success",
//   "data": [...],
//   "message": "Users fetched",
//   "total": 10
// }

class ApiResponse<T> {
  final String status;
  final T data;
  final String? message;
  final int? total;

  ApiResponse({
    required this.status,
    required this.data,
    this.message,
    this.total,
  });

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) parseData,
  ) {
    return ApiResponse(
      status: json['status'] ?? 'unknown',
      data: parseData(json['data']),
      message: json['message'],
      total: json['total'],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN - DEMONSTRATION
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  print('═' * 60);
  print('EXAMPLE 05: Data Models in Action');
  print('═' * 60);
  print('');

  // ─────────────────────────────────────────────────────────────
  // 1. Parse a single user from JSON
  // ─────────────────────────────────────────────────────────────
  print('1. PARSING SINGLE USER');
  print('─' * 40);

  const userJson = '''
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  }
  ''';

  final userData = json.decode(userJson);
  final user = User.fromJson(userData);

  print(user.displayInfo);
  print('');

  // ─────────────────────────────────────────────────────────────
  // 2. Access nested properties
  // ─────────────────────────────────────────────────────────────
  print('2. ACCESSING NESTED PROPERTIES');
  print('─' * 40);

  print('City: ${user.address.city}');
  print('Zipcode: ${user.address.zipcode}');
  print('Latitude: ${user.address.geo?.lat}');
  print('Company Name: ${user.company?.name}');
  print('Company Catch Phrase: ${user.company?.catchPhrase}');
  print('');

  // ─────────────────────────────────────────────────────────────
  // 3. Use copyWith for immutable updates
  // ─────────────────────────────────────────────────────────────
  print('3. USING COPYWITH');
  print('─' * 40);

  final updatedUser = user.copyWith(
    name: 'Leanne Graham Updated',
    email: 'new.email@example.com',
  );

  print('Original name: ${user.name}');
  print('Updated name: ${updatedUser.name}');
  print('Original email: ${user.email}');
  print('Updated email: ${updatedUser.email}');
  print('');

  // ─────────────────────────────────────────────────────────────
  // 4. Parse list of users
  // ─────────────────────────────────────────────────────────────
  print('4. PARSING LIST OF USERS');
  print('─' * 40);

  const usersJson = '''
  [
    {"id": 1, "name": "John", "username": "john", "email": "john@test.com", "address": {"street": "123 Main", "suite": "Apt 1", "city": "NYC", "zipcode": "10001"}},
    {"id": 2, "name": "Jane", "username": "jane", "email": "jane@test.com", "address": {"street": "456 Oak", "suite": "Suite 2", "city": "LA", "zipcode": "90001"}},
    {"id": 3, "name": "Bob", "username": "bob", "email": "bob@test.com", "address": {"street": "789 Pine", "suite": "", "city": "Chicago", "zipcode": "60601"}}
  ]
  ''';

  final List<dynamic> usersData = json.decode(usersJson);
  final List<User> users = usersData.map((data) => User.fromJson(data)).toList();

  print('Parsed ${users.length} users:');
  for (final u in users) {
    print('  - ${u.name} (${u.email}) - ${u.address.city}');
  }
  print('');

  // ─────────────────────────────────────────────────────────────
  // 5. Convert back to JSON
  // ─────────────────────────────────────────────────────────────
  print('5. CONVERTING BACK TO JSON');
  print('─' * 40);

  final backToJson = user.toJson();
  final jsonString = JsonEncoder.withIndent('  ').convert(backToJson);

  print('User as JSON:');
  print(jsonString);
  print('');

  // ─────────────────────────────────────────────────────────────
  // 6. API Response wrapper example
  // ─────────────────────────────────────────────────────────────
  print('6. API RESPONSE WRAPPER');
  print('─' * 40);

  const apiResponseJson = '''
  {
    "status": "success",
    "data": [
      {"id": 1, "name": "User 1", "username": "u1", "email": "u1@test.com", "address": {"street": "St 1", "suite": "", "city": "City 1", "zipcode": "11111"}},
      {"id": 2, "name": "User 2", "username": "u2", "email": "u2@test.com", "address": {"street": "St 2", "suite": "", "city": "City 2", "zipcode": "22222"}}
    ],
    "message": "Users fetched successfully",
    "total": 2
  }
  ''';

  final responseData = json.decode(apiResponseJson);
  final apiResponse = ApiResponse<List<User>>.fromJson(
    responseData,
    (data) => (data as List).map((u) => User.fromJson(u)).toList(),
  );

  print('Status: ${apiResponse.status}');
  print('Is Success: ${apiResponse.isSuccess}');
  print('Message: ${apiResponse.message}');
  print('Total: ${apiResponse.total}');
  print('Users:');
  for (final u in apiResponse.data) {
    print('  - ${u.name}');
  }
  print('');

  // ─────────────────────────────────────────────────────────────
  // 7. Handling missing/null fields
  // ─────────────────────────────────────────────────────────────
  print('7. HANDLING MISSING FIELDS');
  print('─' * 40);

  const incompleteJson = '''
  {
    "id": 99,
    "name": "Minimal User",
    "address": {
      "city": "Unknown City"
    }
  }
  ''';

  final incompleteData = json.decode(incompleteJson);
  final incompleteUser = User.fromJson(incompleteData);

  print('Parsed user with missing fields:');
  print('  ID: ${incompleteUser.id}');
  print('  Name: ${incompleteUser.name}');
  print('  Username: "${incompleteUser.username}" (empty default)');
  print('  Email: "${incompleteUser.email}" (empty default)');
  print('  Phone: ${incompleteUser.phone} (null)');
  print('  Company: ${incompleteUser.company} (null)');
  print('  City: ${incompleteUser.address.city}');
  print('');

  print('═' * 60);
  print('END OF EXAMPLE');
  print('═' * 60);
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY TAKEAWAYS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. DATA MODEL PATTERN:
//    - Define class with final fields
//    - factory fromJson() for parsing
//    - toJson() for serialization
//    - copyWith() for immutable updates
//
// 2. NESTED OBJECTS:
//    - Create separate classes for nested data
//    - Parse with NestedClass.fromJson(json['nested'])
//
// 3. NULLABLE FIELDS:
//    - Use String? for optional fields
//    - Use null check before parsing: json['field'] != null
//    - Use ?? for defaults: json['field'] ?? 'default'
//
// 4. LISTS OF OBJECTS:
//    - (jsonList as List).map((e) => Model.fromJson(e)).toList()
//
// 5. TYPE SAFETY:
//    - Handle string-to-number conversion
//    - Provide sensible defaults
//    - Use null safety
//
// ═══════════════════════════════════════════════════════════════════════════
