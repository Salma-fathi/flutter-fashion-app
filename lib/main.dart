import 'package:flutter/material.dart';
import 'package:fashion_app/config/kinetic_theme.dart';
import 'package:fashion_app/screens/main_screen.dart';

void main() {
  runApp(const KineticFashionApp());
}

class KineticFashionApp extends StatelessWidget {
  const KineticFashionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KINETIC - Premium Fashion',
      debugShowCheckedModeBanner: false,
      theme: KineticTheme.getLightTheme(),
      darkTheme: KineticTheme.getDarkTheme(),
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
