import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/providers/favorites_provider.dart';
import 'package:recipes/screens/categories.dart';
import 'package:recipes/screens/filters.dart';
import 'package:recipes/screens/meals.dart';
import 'package:recipes/screens/local_screen.dart'; // Import LocalScreen
import 'package:recipes/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<String, bool>>(
        MaterialPageRoute(builder: (context) => const FiltersScreen()),
      );
    } else if (identifier == 'local') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const LocalScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(meals: favoriteMeals, title: 'Your Favorites');
      activePageTitle = 'Favorites';
    } else if (_selectedPageIndex == 2) {
      activePage = const LocalScreen();
      // activePageTitle = 'Local Recipes';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: MainDrawer(onSelectScreen: _setScreen),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          activePageTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 151, 151, 151).withAlpha(64),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu, size: 32),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star, size: 32),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage, size: 32),
              label: 'Local',
            ),
          ],
        ),
      ),
    );
  }
}
