// Exercise 3: Unique Items (SOLUTION)

void main() {
  print('=== Set Operations Demo ===\n');

  // Create Sets
  Set<String> fruits = {'Apple', 'Banana', 'Orange'};
  print('Fruits: $fruits');

  // Try adding duplicates
  fruits.add('Apple'); // Won't add duplicate
  fruits.add('Mango'); // Will add
  print('After adding Apple again and Mango: $fruits\n');

  // Set operations
  Set<String> tropicalFruits = {'Mango', 'Pineapple', 'Banana'};
  print('Tropical Fruits: $tropicalFruits\n');

  // Union
  Set<String> allFruits = fruits.union(tropicalFruits);
  print('Union (all fruits): $allFruits');

  // Intersection
  Set<String> common = fruits.intersection(tropicalFruits);
  print('Intersection (common): $common');

  // Difference
  Set<String> onlyInFruits = fruits.difference(tropicalFruits);
  print('Difference (only in fruits): $onlyInFruits\n');

  // Convert List to Set (removes duplicates)
  List<int> numbersWithDuplicates = [1, 2, 3, 2, 4, 3, 5, 1];
  Set<int> uniqueNumbers = numbersWithDuplicates.toSet();
  print('List with duplicates: $numbersWithDuplicates');
  print('Set (unique only): $uniqueNumbers');

  // Convert Set back to List
  List<int> backToList = uniqueNumbers.toList();
  print('Back to List: $backToList');
}
