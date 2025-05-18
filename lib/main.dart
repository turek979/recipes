import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes/screens/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/data/database_helper.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 255, 255, 255),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: const TabsScreen());
  }
}
