/// Exercise 1: Working with Futures - Async Data Fetcher
///
/// Level: Beginner
///
/// Task:
/// Create a DataFetcher class that simulates fetching data from various sources
/// using Futures. Practice async/await, error handling, and Future combinators.
///
/// Requirements:
/// 1. Create DataFetcher class with methods:
///    - Future<String> fetchUserData(String userId)
///    - Future<List<String>> fetchUserPosts(String userId)
///    - Future<Map<String, dynamic>> fetchUserProfile(String userId)
///    - Future<void> saveData(String data)
///
/// 2. Implement realistic delays (use Future.delayed):
///    - fetchUserData: 2 seconds
///    - fetchUserPosts: 3 seconds
///    - fetchUserProfile: 1 second
///    - saveData: 1 second
///
/// 3. Add error simulation:
///    - Throw error if userId is empty
///    - Throw error for userId "error"
///    - Handle timeouts (max 5 seconds)
///
/// 4. Use Future.wait() to fetch multiple data sources in parallel
/// 5. Implement proper error handling with try-catch

class DataFetcher {
  // TODO: Implement fetchUserData
  Future<String> fetchUserData(String userId) async {
    // Simulate network delay
    // Return user data as string
    throw UnimplementedError();
  }

  // TODO: Implement fetchUserPosts
  Future<List<String>> fetchUserPosts(String userId) async {
    // Simulate network delay
    // Return list of post titles
    throw UnimplementedError();
  }

  // TODO: Implement fetchUserProfile
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    // Simulate network delay
    // Return map with name, email, age
    throw UnimplementedError();
  }

  // TODO: Implement saveData
  Future<void> saveData(String data) async {
    // Simulate saving delay
    throw UnimplementedError();
  }

  // TODO: Implement fetchAllUserData using Future.wait
  Future<Map<String, dynamic>> fetchAllUserData(String userId) async {
    // Fetch user data, posts, and profile in parallel
    // Return combined data
    throw UnimplementedError();
  }
}

// Example usage:
void main() async {
  final fetcher = DataFetcher();

  try {
    print('Fetching user data...');
    final userData = await fetcher.fetchUserData('user123');
    print('User data: $userData');

    print('\nFetching all data in parallel...');
    final allData = await fetcher.fetchAllUserData('user123');
    print('All data: $allData');
  } catch (e) {
    print('Error: $e');
  }
}
