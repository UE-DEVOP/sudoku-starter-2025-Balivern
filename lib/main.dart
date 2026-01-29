import 'package:flutter/material.dart';
import 'package:sudoku_starter/game.dart';
import 'package:sudoku_starter/home.dart';
import 'package:sudoku_starter/end.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku FlutterGames',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Définir la route initiale
      initialRoute: '/',
      // Définir les routes
      routes: {
        '/': (context) => const Home(),
        '/game': (context) => const Game(title: 'Sudoku FlutterGames'),
        '/end': (context) => const End(),
      },
    );
  }
}