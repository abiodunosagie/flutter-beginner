// Week 14, Exercise 1: Simple GET Request
// Difficulty: Beginner
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('Fetching user data...\n');

  try {
    // Make GET request
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
    );

    // Check if successful
    if (response.statusCode == 200) {
      // Parse JSON
      Map<String, dynamic> user = jsonDecode(response.body);

      // Print user details
      print('User Details:');
      print('Name: ${user['name']}');
      print('Email: ${user['email']}');
      print('Phone: ${user['phone']}');
    } else {
      print('Error: Failed to load user (Status: ${response.statusCode})');
    }
  } catch (e) {
    print('Error: $e');
  }
}
