// Week 13, Exercise 3: Create a Data Model
// Difficulty: Intermediate
// Solution

import 'dart:convert';

class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final double price;
  final String isbn;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.price,
    required this.isbn,
  });

  // Factory constructor to create Book from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
      price: json['price'].toDouble(),
      isbn: json['isbn'],
    );
  }

  // Convert Book to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
      'price': price,
      'isbn': isbn,
    };
  }

  // Override toString for easy printing
  @override
  String toString() {
    return 'Book(id: $id, title: "$title", author: "$author", year: $year, price: \$$price, isbn: $isbn)';
  }
}

void main() {
  String jsonString = '''
  {
    "id": 1,
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "year": 2008,
    "price": 42.99,
    "isbn": "978-0132350884"
  }
  ''';

  // Parse JSON to Map
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  // Create Book object from JSON
  Book book = Book.fromJson(jsonMap);

  // Print the book
  print('Parsed Book:');
  print(book);
  print('');

  // Convert back to JSON
  Map<String, dynamic> bookJson = book.toJson();
  String jsonOutput = jsonEncode(bookJson);

  print('Book as JSON:');
  print(jsonOutput);
}
