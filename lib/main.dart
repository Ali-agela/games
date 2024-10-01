import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:movies/providers/games_provider.dart';
import 'package:movies/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  Bool ali = Bool(
    
  );
  print(ali.toString);
  runApp(MultiProvider(providers: [
    ListenableProvider<GamesProvider>(create: (_) => GamesProvider()),
    ListenableProvider<DarkModeProvider>(
        create: (_) => DarkModeProvider()..getMode()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gamefy",
      home: SplashScreen(),
    );
  }
}
