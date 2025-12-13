// Week 14, Exercise 2: GET with Query Parameters and Filtering
// Difficulty: Beginner-Intermediate
// Solution

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('Fetching posts for user 1...\n');

  try {
    // Build URI with query parameters
    final uri = Uri.https(
      'jsonplaceholder.typicode.com',
      '/posts',
      {'userId': '1'},
    );

    // Make GET request
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse response
      List<dynamic> posts = jsonDecode(response.body);

      // Count posts
      print('Total posts: ${posts.length}\n');

      // Find post with most words
      var longestPost = posts[0];
      int maxWords = posts[0]['body'].toString().split(' ').length;

      for (var post in posts) {
        int wordCount = post['body'].toString().split(' ').length;
        if (wordCount > maxWords) {
          maxWords = wordCount;
          longestPost = post;
        }
      }

      print('Longest Post (${maxWords} words):');
      print('Title: ${longestPost['title']}');
      print('Body: ${longestPost['body']}\n');

      // Print all titles
      print('All Post Titles:');
      for (int i = 0; i < posts.length; i++) {
        print('${i + 1}. ${posts[i]['title']}');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
