// Exercise 1: Shopping List (SOLUTION)

void main() {
  // Create shopping list
  List<String> shoppingList = [];

  print('=== Shopping List Manager ===\n');

  // Add items
  shoppingList.add('Milk');
  shoppingList.add('Bread');
  shoppingList.add('Eggs');
  shoppingList.add('Butter');
  shoppingList.add('Cheese');
  print('✓ Added 5 items to the list');

  // Display all items
  print('\nCurrent Shopping List:');
  for (int i = 0; i < shoppingList.length; i++) {
    print('${i + 1}. ${shoppingList[i]}');
  }

  // Check if item exists
  String searchItem = 'Eggs';
  bool hasItem = shoppingList.contains(searchItem);
  print('\nDo we need $searchItem? ${hasItem ? "Yes" : "No"}');

  // Remove an item
  String itemToRemove = 'Bread';
  shoppingList.remove(itemToRemove);
  print('✓ Removed $itemToRemove from the list');

  // Display updated list
  print('\nUpdated Shopping List:');
  for (String item in shoppingList) {
    print('• $item');
  }

  // Display count
  print('\nTotal items: ${shoppingList.length}');
}
