import 'package:flutter/material.dart';
import 'package:recipes/models/meal.dart';
import 'package:recipes/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, this.title, required this.meals});

  final String? title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(meal: meals[index]),
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh ... nothing here!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Try selecting a different category',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    if (title == null) {
      return content;
    }

    return Scaffold(appBar: AppBar(title: Text(title!)), body: content);
  }
}
