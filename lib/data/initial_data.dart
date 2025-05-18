import '../models/meal.dart';

final List<Meal> initialMeals = [
  Meal(
    id: 'm1',
    categories: ['african'],
    title: 'Jollof Rice(local)',
    imageUrl: '',

    ingredients: ['Rice', 'Tomatoes', 'Onions', 'Peppers', 'Spices'],
    steps: ['Cook rice', 'Prepare tomato sauce', 'Mix and simmer'],
    duration: 45,
    complexity: Complexity.simple,
    affordability: Affordability.affordable,
    isGlutenFree: true,
    isLactoseFree: true,
    isVegan: false,
    isVegetarian: true,
  ),
  Meal(
    id: 'm2',
    categories: ['american'],
    title: 'Burger(local)',
    imageUrl: '',
    ingredients: ['Beef patty', 'Bun', 'Lettuce', 'Tomato', 'Cheese'],
    steps: ['Grill patty', 'Assemble burger'],
    duration: 30,
    complexity: Complexity.simple,
    affordability: Affordability.pricey,
    isGlutenFree: false,
    isLactoseFree: false,
    isVegan: false,
    isVegetarian: false,
  ),
  // Dodaj więcej przepisów dla każdej kategorii...
];
