// categories.dart
import 'package:flutter/material.dart';
import 'package:recipes/data/dummy_data.dart';
import 'package:recipes/models/category.dart';
import 'package:recipes/models/meal.dart';
import 'package:recipes/screens/meals.dart';
import 'package:recipes/widgets/category_grid_item.dart';
import 'package:recipes/services/recipe_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Category? selectedCategory;
  late Future<List<Meal>> _mealsFuture;
  final Map<String, List<Meal>> _categoryMealsCache = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();

    _mealsFuture = RecipeService.fetchRandomRecipes();
  }

  Future<void> _loadCategoryMeals(Category category) async {
    if (_categoryMealsCache.containsKey(category.id)) {
      return;
    }

    try {
      final meals = await RecipeService.fetchRecipesByCategory(category.id);

      if (!mounted) return;

      setState(() {
        _categoryMealsCache[category.id] = meals;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ${category.title} recipes: $e')),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Meal>>(
        future: _mealsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final allMeals = snapshot.data!;

            return Column(
              children: [
                // Category selector
                SizedBox(
                  height: 80,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: availableCategories.length,
                      itemBuilder: (ctx, index) {
                        final category = availableCategories[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 8),
                          child: CategoryGridItem(
                            category: category,
                            isSelected: selectedCategory?.id == category.id,
                            onSelectCategory: () {
                              _loadCategoryMeals(category);
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                    builder:
                        (context, child) => SlideTransition(
                          position: Tween(
                            begin: const Offset(0, 0.3),
                            end: const Offset(0, 0),
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: child,
                        ),
                  ),
                ),

                // Recipe list
                Expanded(
                  child:
                      selectedCategory != null
                          ? _categoryMealsCache[selectedCategory!.id] == null
                              ? const Center(child: CircularProgressIndicator())
                              : MealsScreen(
                                title: selectedCategory!.title,
                                meals:
                                    _categoryMealsCache[selectedCategory!.id]!,
                              )
                          : MealsScreen(
                            title: 'Random Recipes',
                            meals: allMeals,
                            showAppBar: false,
                          ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
