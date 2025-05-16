import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/services/recipe_service.dart';
import 'package:recipes/models/meal.dart';

final mealsProvider =
    StateNotifierProvider<MealsNotifier, AsyncValue<List<Meal>>>(
      (ref) => MealsNotifier(),
    );

class MealsNotifier extends StateNotifier<AsyncValue<List<Meal>>> {
  MealsNotifier() : super(const AsyncValue.loading()) {
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      final meals = await RecipeService.fetchRandomRecipes();
      state = AsyncValue.data(meals);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
