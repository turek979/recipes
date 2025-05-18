//import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/meal.dart';

class DatabaseHelper {
  static const _databaseName = 'recipeslocal.db';
  static const _databaseVersion = 2;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        duration INTEGER NOT NULL,
        complexity TEXT NOT NULL,
        affordability TEXT NOT NULL,
        isGlutenFree INTEGER NOT NULL,
        isLactoseFree INTEGER NOT NULL,
        isVegan INTEGER NOT NULL,
        isVegetarian INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE meal_categories (
        meal_id TEXT NOT NULL,
        category_id TEXT NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES meals (id),
        PRIMARY KEY (meal_id, category_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id TEXT NOT NULL,
        ingredient TEXT NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES meals (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id TEXT NOT NULL,
        step TEXT NOT NULL,
        FOREIGN KEY (meal_id) REFERENCES meals (id)
      )
    ''');
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.insert('meals', {
          'id': meal.id,
          'title': meal.title,
          'imageUrl': meal.imageUrl,
          'duration': meal.duration,
          'complexity': meal.complexity.name,
          'affordability': meal.affordability.name,
          'isGlutenFree': meal.isGlutenFree ? 1 : 0,
          'isLactoseFree': meal.isLactoseFree ? 1 : 0,
          'isVegan': meal.isVegan ? 1 : 0,
          'isVegetarian': meal.isVegetarian ? 1 : 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        await txn.delete(
          'meal_categories',
          where: 'meal_id = ?',
          whereArgs: [meal.id],
        );
        for (var category in meal.categories) {
          await txn.insert('meal_categories', {
            'meal_id': meal.id,
            'category_id': category,
          });
        }

        await txn.delete(
          'ingredients',
          where: 'meal_id = ?',
          whereArgs: [meal.id],
        );
        for (var ingredient in meal.ingredients) {
          await txn.insert('ingredients', {
            'meal_id': meal.id,
            'ingredient': ingredient,
          });
        }

        await txn.delete('steps', where: 'meal_id = ?', whereArgs: [meal.id]);
        for (var step in meal.steps) {
          await txn.insert('steps', {'meal_id': meal.id, 'step': step});
        }
      });
      logInfo('Posiłek dodany: ${meal.title}');
    } catch (e, stackTrace) {
      logError('Błąd podczas dodawania posiłku: $e\n$stackTrace');
    }
  }

  Future<List<Meal>> getAllMeals() async {
    final db = await database;
    final meals = await db.query('meals');
    final result = <Meal>[];
    for (var mealMap in meals) {
      final meal = await getMealDetails(db, mealMap);
      result.add(meal);
    }
    return result;
  }

  Future<Meal> getMealDetails(Database db, Map<String, dynamic> mealMap) async {
    final categories = await db.rawQuery(
      'SELECT category_id FROM meal_categories WHERE meal_id = ?',
      [mealMap['id']],
    );
    final ingredients = await db.rawQuery(
      'SELECT ingredient FROM ingredients WHERE meal_id = ? ORDER BY id',
      [mealMap['id']],
    );
    final steps = await db.rawQuery(
      'SELECT step FROM steps WHERE meal_id = ? ORDER BY id',
      [mealMap['id']],
    );

    return Meal(
      id: mealMap['id'],
      categories: categories.map((c) => c['category_id'] as String).toList(),
      title: mealMap['title'],
      imageUrl: mealMap['imageUrl'],
      ingredients: ingredients.map((i) => i['ingredient'] as String).toList(),
      steps: steps.map((s) => s['step'] as String).toList(),
      duration: mealMap['duration'],
      complexity: Complexity.values.firstWhere(
        (e) => e.name == mealMap['complexity'],
      ),
      affordability: Affordability.values.firstWhere(
        (e) => e.name == mealMap['affordability'],
      ),
      isGlutenFree: mealMap['isGlutenFree'] == 1,
      isLactoseFree: mealMap['isLactoseFree'] == 1,
      isVegan: mealMap['isVegan'] == 1,
      isVegetarian: mealMap['isVegetarian'] == 1,
    );
  }

  Future<List<Meal>> getMealsByCategory(String categoryId) async {
    final db = await database;
    final meals = await db.rawQuery(
      '''
    SELECT m.* FROM meals m
    JOIN meal_categories mc ON m.id = mc.meal_id
    WHERE mc.category_id = ?
    ''',
      [categoryId],
    );

    final result = <Meal>[];
    for (var mealMap in meals) {
      final meal = await getMealDetails(db, mealMap);
      result.add(meal);
    }
    return result;
  }
}

void logInfo(String message) {
  assert(() {
    //('INFO: $message');
    return true;
  }());
}

void logError(String message) {
  assert(() {
    // print('ERROR: $message');
    return true;
  }());
}
