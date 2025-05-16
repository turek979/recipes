import 'package:flutter/material.dart';
import 'package:recipes/providers/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Filters',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white, // Zmienione tło na biały
        child: Column(
          children: [
            const SizedBox(height: 40),
            SwitchListTile(
              value: activeFilters[Filter.glutenFree]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filter.glutenFree, isChecked);
              },
              title: const Text(
                'Gluten free',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                'Gluten free meals.',
                style: TextStyle(color: Colors.black54),
              ),
              activeColor: const Color(
                0xFF3B3B3B,
              ), // Ciemnoszary przełącznik w aktywnym stanie
              trackColor: WidgetStateProperty.all(
                const Color(0xFF6D6D6D),
              ), // Szary suwak w nieaktywnym stanie
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: activeFilters[Filter.lactoseFree]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filter.lactoseFree, isChecked);
              },
              title: const Text(
                'Lactose free',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                'Lactose free meals.',
                style: TextStyle(color: Colors.black54),
              ),
              activeColor: const Color(0xFF3B3B3B),
              trackColor: WidgetStateProperty.all(const Color(0xFF6D6D6D)),
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: activeFilters[Filter.vegetarian]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filter.vegetarian, isChecked);
              },
              title: const Text(
                'Vegetarian',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                'Vegetarian meals.',
                style: TextStyle(color: Colors.black54),
              ),
              activeColor: const Color(0xFF3B3B3B),
              trackColor: WidgetStateProperty.all(const Color(0xFF6D6D6D)),
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: activeFilters[Filter.vegan]!,
              onChanged: (isChecked) {
                ref
                    .read(filtersProvider.notifier)
                    .setFilter(Filter.vegan, isChecked);
              },
              title: const Text('Vegan', style: TextStyle(color: Colors.black)),
              subtitle: const Text(
                'Vegan meals.',
                style: TextStyle(color: Colors.black54),
              ),
              activeColor: const Color(
                0xFF3B3B3B,
              ), // Ciemnoszary kolor przełącznika
              trackColor: WidgetStateProperty.all(
                const Color(0xFF6D6D6D),
              ), // Szary kolor tła przełącznika
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
