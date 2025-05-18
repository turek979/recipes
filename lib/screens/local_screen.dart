import 'package:flutter/material.dart';
import 'package:recipes/data/database_helper.dart';
import 'package:recipes/models/meal.dart';
import 'package:recipes/screens/meals.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    //print('📦 Pobieram posiłki lokalne...');
    // DatabaseHelper.instance.checkDatabaseContents();
    _mealsFuture = DatabaseHelper.instance.getAllMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Local Recipes'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _mealsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final localMeals = snapshot.data ?? [];

            if (localMeals.isEmpty) {
              return const Center(
                child: Text(
                  'Brak lokalnych przepisów. Dodaj coś do bazy!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: localMeals.length,
              itemBuilder: (context, index) {
                final meal = localMeals[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  color: Colors.white,
                  child: ListTile(
                    leading:
                        meal.imageUrl.isNotEmpty
                            ? Image.network(
                              meal.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              width: 50,
                              height: 50,
                              color: Colors.white,
                            ),

                    title: Text(
                      '${meal.title} (Local)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    subtitle: Text(
                      'Czas przygotowania: ${meal.duration} min',
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  MealsScreen(title: meal.title, meals: [meal]),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
