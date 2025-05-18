import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../data/database_helper.dart';

class RecipeService {
  static const _apiKey = '...';
  static const _baseUrl = 'https://api.spoonacular.com/recipes';
  static final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  static Future<List<Meal>> fetchRandomRecipes({int number = 10}) async {
    try {
      final url = Uri.parse('$_baseUrl/random?number=$number&apiKey=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List recipes = data['recipes'];
        final List<Meal> apiMeals =
            recipes.map((json) => _convertApiMeal(json)).toList();

        for (final meal in apiMeals) {
          await _dbHelper.insertMeal(meal);
        }

        return apiMeals;
      } else {
        final localMeals = await _dbHelper.getAllMeals();
        return localMeals..shuffle();
      }
    } catch (e) {
      final localMeals = await _dbHelper.getAllMeals();
      return localMeals..shuffle();
    }
  }

  static Future<List<Meal>> fetchRecipesByCategory(String categoryId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/complexSearch?apiKey=$_apiKey&cuisine=$categoryId&number=10',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List recipes = data['results'];
        final List<Meal> meals = [];

        for (var recipe in recipes) {
          try {
            final meal = await fetchRecipeDetails(recipe['id'].toString());
            meals.add(meal);
            await _dbHelper.insertMeal(meal);
          } catch (e) {
            continue;
          }
        }
        return meals;
      } else {
        return await _dbHelper.getMealsByCategory(categoryId);
      }
    } catch (e) {
      return await _dbHelper.getMealsByCategory(categoryId);
    }
  }

  static Future<Meal> fetchRecipeDetails(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/$id/information?apiKey=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meal = _convertApiMeal(data);
        await _dbHelper.insertMeal(meal);
        return meal;
      } else {
        throw Exception(
          'Failed to load recipe details: ${response.statusCode}',
        );
      }
    } catch (e) {
      final db = await _dbHelper.database;
      final mealMap = await db.query(
        'meals',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (mealMap.isNotEmpty) {
        return await _dbHelper.getMealDetails(db, mealMap.first);
      } else {
        throw Exception('Recipe not found in local database');
      }
    }
  }

  static Meal _convertApiMeal(Map<String, dynamic> json) {
    return Meal(
      id: json['id'].toString(),
      categories: List<String>.from(json['cuisines'] ?? []),
      title: json['title'] ?? 'No title',
      imageUrl: json['image'] ?? '',
      ingredients: _extractIngredients(json),
      steps: _extractInstructions(json),
      duration: json['readyInMinutes'] ?? 0,
      complexity: _mapComplexity(json),
      affordability: _mapAffordability(json),
      isGlutenFree: json['glutenFree'] ?? false,
      isLactoseFree: json['dairyFree'] ?? false,
      isVegan: json['vegan'] ?? false,
      isVegetarian: json['vegetarian'] ?? false,
    );
  }

  static List<String> _extractIngredients(Map<String, dynamic> json) {
    if (json['extendedIngredients'] != null) {
      return List<String>.from(
        json['extendedIngredients'].map((i) => i['original']),
      );
    }
    return [];
  }

  static List<String> _extractInstructions(Map<String, dynamic> json) {
    if (json['analyzedInstructions'] != null &&
        json['analyzedInstructions'].isNotEmpty) {
      return List<String>.from(
        json['analyzedInstructions'][0]['steps'].map((s) => s['step']),
      );
    }
    return ['No instructions provided'];
  }

  static Complexity _mapComplexity(Map<String, dynamic> json) {
    final time = json['readyInMinutes'] ?? 0;
    if (time < 20) return Complexity.simple;
    if (time < 45) return Complexity.challenging;
    return Complexity.hard;
  }

  static Affordability _mapAffordability(Map<String, dynamic> json) {
    final price = json['pricePerServing'] ?? 0;
    if (price < 50) return Affordability.affordable;
    if (price < 150) return Affordability.pricey;
    return Affordability.luxurious;
  }
}
