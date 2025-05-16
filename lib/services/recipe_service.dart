import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class RecipeService {
  static const _apiKey = '17f94347ac3d4f418b44514266a4f407';
  static const _baseUrl = 'https://api.spoonacular.com/recipes';

  static Future<List<Meal>> fetchRandomRecipes({int number = 10}) async {
    final url = Uri.parse('$_baseUrl/random?number=$number&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List recipes = data['recipes'];
      return recipes.map((json) => _convertApiMeal(json)).toList();
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }

  static Future<List<Meal>> fetchRecipesByCategory(String categoryId) async {
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
        } catch (e) {
          continue;
        }
      }
      return meals;
    } else {
      throw Exception(
        'Failed to load category recipes: ${response.statusCode}',
      );
    }
  }

  static Future<Meal> fetchRecipeDetails(String id) async {
    final url = Uri.parse('$_baseUrl/$id/information?apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _convertApiMeal(data);
    } else {
      throw Exception('Failed to load recipe details: ${response.statusCode}');
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
