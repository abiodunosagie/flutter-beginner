# Project B: Recipe Book App

## Overview

Build a personal recipe collection app where users can save, organize, and view their favorite recipes.

```
┌─────────────────────────────────────────────────────────┐
│                    RECIPE BOOK                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  "Your personal cookbook in your pocket"                 │
│                                                          │
│  Features:                                               │
│  ├── Save and manage recipes                            │
│  ├── Organize by meal type                              │
│  ├── Add ingredients and steps                          │
│  ├── Mark favorites                                     │
│  └── Search recipes                                     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Core Features (Required)

### 1. Recipe Management

```
MUST HAVE:
□ Create new recipes
□ View list of all recipes
□ View recipe details
□ Edit existing recipes
□ Delete recipes
□ Recipes persist when app restarts
```

### 2. Recipe Details

```
Each recipe should have:
├── Name (required)
├── Description (optional)
├── Category (Breakfast, Lunch, Dinner, Dessert)
├── Ingredients list
├── Cooking steps
├── Prep time
├── Cook time
└── Favorite status
```

### 3. Organization

```
MUST HAVE:
□ Filter by category
□ Mark recipes as favorites
□ View only favorites
□ Search recipes by name
```

---

## Screens

### Screen 1: Home Screen

```
┌─────────────────────────────────────┐
│  [≡]  My Recipes          [🔍]     │
├─────────────────────────────────────┤
│                                     │
│  ┌─ All ─┬─ Favorites ─┐           │
│  └───────┴─────────────┘           │
│                                     │
│  Categories                         │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐      │
│  │🌅 │ │☀️ │ │🌙 │ │🍰 │      │
│  │Bkft│ │Lnch│ │Dinr│ │Dsrt│      │
│  └────┘ └────┘ └────┘ └────┘      │
│                                     │
│  Recent Recipes                     │
│  ┌─────────────────────────────┐   │
│  │ 🍝 Spaghetti Carbonara      │   │
│  │ Dinner • 30 min    [♥]      │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 🥗 Caesar Salad             │   │
│  │ Lunch • 15 min     [♡]      │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 🥞 Fluffy Pancakes          │   │
│  │ Breakfast • 20 min [♥]      │   │
│  └─────────────────────────────┘   │
│                                     │
│                          [+ Add]   │
└─────────────────────────────────────┘
```

### Screen 2: Add/Edit Recipe

```
┌─────────────────────────────────────┐
│  [←]  New Recipe         [Save]    │
├─────────────────────────────────────┤
│                                     │
│  Recipe Name *                      │
│  ┌─────────────────────────────┐   │
│  │ Enter recipe name...        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Description                        │
│  ┌─────────────────────────────┐   │
│  │ Brief description...        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Category                           │
│  ┌───────────┐ ┌───────────┐       │
│  │ Breakfast │ │   Lunch   │       │
│  └───────────┘ └───────────┘       │
│  ┌───────────┐ ┌───────────┐       │
│  │  Dinner   │ │  Dessert  │       │
│  └───────────┘ └───────────┘       │
│                                     │
│  ⏱️ Prep: [15] min  Cook: [30] min │
│                                     │
│  Ingredients                        │
│  ┌─────────────────────────────┐   │
│  │ • 200g pasta                │   │
│  │ • 2 eggs                    │   │
│  │ • 100g bacon                │   │
│  │ [+ Add ingredient]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  Steps                              │
│  ┌─────────────────────────────┐   │
│  │ 1. Boil water and cook...   │   │
│  │ 2. Fry the bacon until...   │   │
│  │ [+ Add step]                │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Screen 3: Recipe Detail

```
┌─────────────────────────────────────┐
│  [←]  Recipe          [♥] [✏️]     │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │      🍝 [Image/Icon]        │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Spaghetti Carbonara                │
│  ⭐ Dinner                          │
│                                     │
│  ⏱️ Prep: 15 min • Cook: 30 min    │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  📝 Description                     │
│  A classic Italian pasta dish       │
│  with creamy egg sauce.             │
│                                     │
│  🛒 Ingredients (4)                 │
│  • 200g spaghetti                   │
│  • 2 large eggs                     │
│  • 100g pancetta                    │
│  • 50g parmesan                     │
│                                     │
│  👨‍🍳 Steps (4)                       │
│  1. Boil water and cook pasta      │
│     according to package.           │
│                                     │
│  2. Fry pancetta until crispy.     │
│                                     │
│  3. Mix eggs with parmesan.        │
│                                     │
│  4. Combine all ingredients and    │
│     serve immediately.              │
│                                     │
└─────────────────────────────────────┘
```

### Screen 4: Search Screen

```
┌─────────────────────────────────────┐
│  [←]  Search                        │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ 🔍 Search recipes...        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Results for "pasta"                │
│  ┌─────────────────────────────┐   │
│  │ 🍝 Spaghetti Carbonara      │   │
│  │ Dinner • 45 min             │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 🍜 Penne Arrabbiata         │   │
│  │ Dinner • 30 min             │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## Data Model

```dart
// models/recipe.dart
class Recipe {
  final String id;
  final String name;
  final String? description;
  final String category; // breakfast, lunch, dinner, dessert
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.steps,
    this.isFavorite = false,
    required this.createdAt,
  });

  int get totalTime => prepTimeMinutes + cookTimeMinutes;

  // Add toMap, fromMap, copyWith methods
}
```

---

## Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── models/
│   └── recipe.dart
│
├── services/
│   └── database_service.dart
│
├── providers/
│   └── recipe_provider.dart
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── recipe_grid.dart
│   │       ├── category_row.dart
│   │       └── recipe_card.dart
│   ├── recipe/
│   │   ├── add_recipe_screen.dart
│   │   ├── edit_recipe_screen.dart
│   │   └── recipe_detail_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   └── splash_screen.dart
│
├── widgets/
│   ├── recipe_tile.dart
│   ├── category_chip.dart
│   ├── ingredient_input.dart
│   ├── step_input.dart
│   └── empty_state.dart
│
└── config/
    ├── theme.dart
    ├── routes.dart
    └── categories.dart
```

---

## Implementation Steps

### Phase 1: Foundation

```
□ Create Flutter project
□ Set up folder structure
□ Add dependencies
□ Create Recipe model with toMap/fromMap
□ Handle ingredients/steps as JSON strings in SQLite
□ Set up DatabaseService
□ Create recipes table
```

### Phase 2: Core Features

```
□ Create RecipeProvider
□ Implement loadRecipes()
□ Build HomeScreen with recipe list
□ Create RecipeCard widget
□ Implement addRecipe()
□ Build AddRecipeScreen with dynamic lists
□ Implement deleteRecipe()
□ Build RecipeDetailScreen
```

### Phase 3: Organization

```
□ Add category filter
□ Create CategoryChip widget
□ Implement toggleFavorite()
□ Add favorites tab
□ Implement search functionality
□ Build SearchScreen
```

### Phase 4: Polish

```
□ Add loading states
□ Add empty states
□ Add error handling
□ Style recipe cards nicely
□ Add delete confirmation
□ Add success/error snackbars
□ Create splash screen
□ Test all features
```

---

## Bonus Features (Optional)

```
NICE TO HAVE:
□ Add photo for each recipe
□ Cooking timer built-in
□ Serving size calculator
□ Share recipe as text
□ Import recipes from text
□ Shopping list generator
□ Nutrition information
□ Rating system (1-5 stars)
□ Cooking mode (step by step)
□ Print-friendly view
```

---

## Handling Lists in SQLite

Since SQLite doesn't support arrays, store ingredients and steps as JSON:

```dart
// Converting for storage
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'name': name,
    'ingredients': jsonEncode(ingredients), // List to JSON string
    'steps': jsonEncode(steps),             // List to JSON string
    // ... other fields
  };
}

// Converting from storage
factory Recipe.fromMap(Map<String, dynamic> map) {
  return Recipe(
    id: map['id'],
    name: map['name'],
    ingredients: List<String>.from(jsonDecode(map['ingredients'])),
    steps: List<String>.from(jsonDecode(map['steps'])),
    // ... other fields
  );
}
```

---

## Packages to Use

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  sqflite: ^2.3.0
  path: ^1.8.3
  intl: ^0.18.1
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

---

## Grading Criteria

```
BASIC (Pass) - 60%
□ Can add recipes with ingredients/steps
□ Can view recipe list
□ Can view recipe details
□ Can delete recipes
□ Data persists

GOOD (B Grade) - 75%
□ All basic features
□ Categories work
□ Favorites work
□ UI looks clean
□ Loading/empty states

EXCELLENT (A Grade) - 90%
□ All good features
□ Search works
□ Edit recipes works
□ Error handling
□ Smooth animations
□ Well organized code

OUTSTANDING (A+ Grade) - 100%
□ All excellent features
□ Bonus features
□ Unit tests
□ Widget tests
□ Exceptional polish
```

---

## Tips for Success

```
1. DYNAMIC LISTS ARE TRICKY
   Start with a fixed number of ingredients/steps.
   Add dynamic add/remove later.

2. TEST DATA EARLY
   Create 3-4 sample recipes to test with.
   Makes development much easier.

3. DESIGN FIRST
   Sketch your recipe card layout before coding.
   It's easier to code when you know what it looks like.

4. KEEP IT SIMPLE
   A recipe doesn't need a photo to work.
   Add fancy features after basics work.

5. MAKE IT PERSONAL
   Add your own favorite recipes!
   It's more fun to build something you'll use.
```

---

Good luck and happy cooking! 🍳
