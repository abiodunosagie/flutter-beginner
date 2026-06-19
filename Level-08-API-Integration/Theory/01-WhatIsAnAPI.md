# What is an API?

## The Big Idea In One Sentence

> An API is a waiter: your app gives it an order (a request), it carries that to the kitchen (the server), and brings back your food (the data).

Learn the fundamentals of APIs and how they enable app-to-server communication!

> **New word: async.** Talking to the internet takes time (the food does not appear instantly). The code below uses `async` and `await`, which mean "start this, and wait for the answer to come back." You will learn `async`/`await` and `Future` step by step in this very level. For now, read `await` as "wait here until the data arrives."

---

## The Simple Explanation

### Think of it Like This

Imagine you want to check the weather:

**Without an API:**
```
You → Travel to weather station → Read instruments → Travel back
     (Impossible and impractical!)
```

**With an API:**
```
You → Ask phone app → App asks weather API → API gives data → App shows weather
     (Easy and instant!)
```

---

## API = Application Programming Interface

```
┌─────────────────────────────────────────────────────────────┐
│                    WHAT IS AN API?                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  A = Application    (A program/app)                         │
│  P = Programming    (Code/instructions)                     │
│  I = Interface      (A way to communicate)                  │
│                                                             │
│  API = A way for programs to talk to each other             │
│                                                             │
│  ┌──────────┐         ┌──────────┐         ┌──────────┐    │
│  │ Your App │ ←─API─→ │  Server  │ ←─API─→ │ Database │    │
│  └──────────┘         └──────────┘         └──────────┘    │
│                                                             │
│  APIs are like CONTRACTS:                                   │
│  "If you ask in THIS format, I'll respond in THAT format"   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## The Restaurant Analogy

```
┌─────────────────────────────────────────────────────────────┐
│                RESTAURANT = API SYSTEM                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  YOU (Customer)          =  Your Flutter App                │
│  MENU                    =  API Documentation               │
│  WAITER                  =  The API                         │
│  KITCHEN                 =  The Server                      │
│  YOUR ORDER              =  HTTP Request                    │
│  YOUR FOOD               =  HTTP Response (data)            │
│                                                             │
│  ┌────────────────────────────────────────────────────┐     │
│  │                                                    │     │
│  │  👤 Customer: "I'd like item #5, please"          │     │
│  │                    ↓                               │     │
│  │  🤵 Waiter: Takes order to kitchen                │     │
│  │                    ↓                               │     │
│  │  👨‍🍳 Kitchen: Prepares item #5                     │     │
│  │                    ↓                               │     │
│  │  🤵 Waiter: Brings food to customer               │     │
│  │                    ↓                               │     │
│  │  👤 Customer: Receives and enjoys food            │     │
│  │                                                    │     │
│  └────────────────────────────────────────────────────┘     │
│                                                             │
│  You don't need to know HOW the kitchen works!              │
│  You just need to know how to ORDER (use the API).          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## REST API - The Most Common Type

### REST = REpresentational State Transfer

```
┌─────────────────────────────────────────────────────────────┐
│                    REST API CONCEPTS                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  REST APIs use:                                             │
│  • URLs to identify resources (things)                      │
│  • HTTP methods to perform actions                          │
│  • JSON/XML to format data                                  │
│                                                             │
│  RESOURCES (Things you can work with):                      │
│  ─────────────────────────────────────                      │
│  /users          →  All users                               │
│  /users/5        →  User with ID 5                          │
│  /users/5/posts  →  Posts by user 5                         │
│  /products       →  All products                            │
│  /orders/123     →  Order #123                              │
│                                                             │
│  ACTIONS (What you can do):                                 │
│  ──────────────────────────                                 │
│  GET     →  Read/Fetch data                                 │
│  POST    →  Create new data                                 │
│  PUT     →  Update/Replace data                             │
│  DELETE  →  Remove data                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Anatomy of an API Request

### The URL (Address)

```
https://api.example.com/users/5/posts?status=published&limit=10
└─┬──┘ └──────┬───────┘└────┬────┘└──────────┬────────────────┘
  │           │              │                │
Protocol    Domain         Path        Query Parameters
(secure)   (server)    (resource)      (filters/options)
```

### The Request Components

```
┌─────────────────────────────────────────────────────────────┐
│                    HTTP REQUEST                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. METHOD: What action?                                    │
│     GET, POST, PUT, DELETE, PATCH                           │
│                                                             │
│  2. URL: Where to send it?                                  │
│     https://api.example.com/users                           │
│                                                             │
│  3. HEADERS: Extra info about the request                   │
│     Content-Type: application/json                          │
│     Authorization: Bearer token123                          │
│                                                             │
│  4. BODY: Data to send (for POST, PUT)                     │
│     {                                                       │
│       "name": "John",                                       │
│       "email": "john@example.com"                           │
│     }                                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Anatomy of an API Response

```
┌─────────────────────────────────────────────────────────────┐
│                    HTTP RESPONSE                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. STATUS CODE: Was it successful?                         │
│     200 = OK (success!)                                     │
│     201 = Created (new thing made!)                         │
│     400 = Bad Request (you messed up)                       │
│     401 = Unauthorized (need to login)                      │
│     404 = Not Found (doesn't exist)                         │
│     500 = Server Error (they messed up)                     │
│                                                             │
│  2. HEADERS: Info about the response                        │
│     Content-Type: application/json                          │
│     Content-Length: 1234                                    │
│                                                             │
│  3. BODY: The actual data                                   │
│     {                                                       │
│       "id": 1,                                              │
│       "name": "John",                                       │
│       "email": "john@example.com"                           │
│     }                                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Status Codes - The Quick Guide

```
┌─────────────────────────────────────────────────────────────┐
│                    STATUS CODES                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  2XX = SUCCESS! 🎉                                          │
│  ──────────────                                             │
│  200 OK              - Request succeeded                    │
│  201 Created         - New resource created                 │
│  204 No Content      - Success, but nothing to return       │
│                                                             │
│  4XX = CLIENT ERROR (Your fault) 😅                         │
│  ──────────────────────────────────                         │
│  400 Bad Request     - Invalid request format               │
│  401 Unauthorized    - Need to login                        │
│  403 Forbidden       - Not allowed                          │
│  404 Not Found       - Resource doesn't exist               │
│  422 Unprocessable   - Validation failed                    │
│                                                             │
│  5XX = SERVER ERROR (Their fault) 😱                        │
│  ─────────────────────────────────                          │
│  500 Internal Error  - Something broke on server            │
│  502 Bad Gateway     - Server communication error           │
│  503 Service Unavail - Server is down/overloaded            │
│                                                             │
│  EASY MEMORY TRICK:                                         │
│  2 = Success | 4 = You messed up | 5 = They messed up       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Real Example: Getting User Data

### The Request

```dart
// We want to get user #1 from JSONPlaceholder (a fake API for testing)
// URL: https://jsonplaceholder.typicode.com/users/1

GET https://jsonplaceholder.typicode.com/users/1
```

### The Response

```json
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874"
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net"
  }
}
```

### In Flutter

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchUser() async {
  // 1. Make the request
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
  );

  // 2. Check if successful
  if (response.statusCode == 200) {
    // 3. Parse the JSON
    final user = json.decode(response.body);

    // 4. Use the data
    print('Name: ${user['name']}');
    print('Email: ${user['email']}');
  } else {
    print('Error: ${response.statusCode}');
  }
}
```

---

## Common API Patterns

### List of Items

```
GET /users
Response: [
  { "id": 1, "name": "John" },
  { "id": 2, "name": "Jane" },
  { "id": 3, "name": "Bob" }
]
```

### Single Item

```
GET /users/1
Response: { "id": 1, "name": "John", "email": "john@test.com" }
```

### Create Item

```
POST /users
Body: { "name": "Alice", "email": "alice@test.com" }
Response: { "id": 4, "name": "Alice", "email": "alice@test.com" }
```

### Update Item

```
PUT /users/1
Body: { "name": "John Updated", "email": "john.new@test.com" }
Response: { "id": 1, "name": "John Updated", "email": "john.new@test.com" }
```

### Delete Item

```
DELETE /users/1
Response: 204 No Content (success, nothing to return)
```

---

## API Documentation

Every API should have documentation that tells you:

```
┌─────────────────────────────────────────────────────────────┐
│                    API DOCUMENTATION                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. BASE URL: Where to make requests                        │
│     Example: https://api.myservice.com/v1                   │
│                                                             │
│  2. ENDPOINTS: Available paths                              │
│     GET /users - List all users                             │
│     GET /users/:id - Get one user                           │
│     POST /users - Create user                               │
│                                                             │
│  3. PARAMETERS: What data to send                           │
│     - Required: name (string)                               │
│     - Optional: age (number)                                │
│                                                             │
│  4. RESPONSES: What you'll get back                         │
│     - 200: { id, name, email }                              │
│     - 404: { error: "Not found" }                           │
│                                                             │
│  5. AUTHENTICATION: How to prove who you are                │
│     - API Key in header                                     │
│     - OAuth token                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    API BASICS SUMMARY                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  API = Way for apps to communicate                          │
│                                                             │
│  REST API = Most common type, uses:                         │
│  • URLs for resources (/users, /posts)                      │
│  • HTTP methods for actions (GET, POST, etc.)               │
│  • JSON for data format                                     │
│                                                             │
│  REQUEST = What you send                                    │
│  • Method, URL, Headers, Body                               │
│                                                             │
│  RESPONSE = What you get back                               │
│  • Status code, Headers, Body (data)                        │
│                                                             │
│  STATUS CODES:                                              │
│  • 2XX = Success                                            │
│  • 4XX = Your mistake                                       │
│  • 5XX = Server mistake                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** In the restaurant analogy, what is the API?

<details>
<summary>Answer</summary>
The waiter, who carries your order to the kitchen (server) and brings back your food (data).
</details>

**Q2.** What does a status code in the 2XX range mean? And 4XX?

<details>
<summary>Answer</summary>
2XX means success. 4XX means the client (your request) made a mistake. (5XX means the server had a problem.)
</details>

**Q3.** Which HTTP method reads/fetches data without changing anything?

<details>
<summary>Answer</summary>
`GET`.
</details>

---

## Assignment

### Problem 1: Match the method

For each action, pick the HTTP method (GET, POST, PUT, DELETE):
1. Load the list of products.
2. Add a new product.
3. Remove a product.

### Problem 2: Read the status code

An API responds with `404`. What does that mean, and whose "fault" is it (you or the server)?

### Problem 3: Name the parts

In `https://api.example.com/users/5`, which part is the resource you are asking for?

---

## Assignment Answers

### Problem 1: Match the method

1. **GET** (read the list).
2. **POST** (create new data).
3. **DELETE** (remove data).

### Problem 2: Read the status code

`404` means "Not Found", the resource does not exist. It is a 4XX code, so it is the client's side (you asked for something that is not there).

### Problem 3: Name the parts

`/users/5` is the resource path: user number 5. (`https://` is the protocol, `api.example.com` is the server/domain.)

---

[← Back to Level 08 README](../README.md) | [Next: HTTP Methods →](./02-HTTPMethods.md)

---

## Navigation

⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [HTTP Methods](02-HTTPMethods.md)
