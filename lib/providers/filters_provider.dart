// filters_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/providers/meals_provider.dart';
import '../models/meal.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegetarian: false,
        Filter.vegan: false,
      });

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
      (ref) => FiltersNotifier(),
    );

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final mealsState = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return mealsState.maybeWhen(
    data:
        (meals) =>
            meals.where((meal) {
              if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
                return false;
              }
              if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
                return false;
              }
              if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
                return false;
              }
              if (activeFilters[Filter.vegan]! && !meal.isVegan) {
                return false;
              }
              return true;
            }).toList(),
    orElse: () => [],
  );
});
