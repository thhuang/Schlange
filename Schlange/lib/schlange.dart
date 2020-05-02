import 'package:Schlange/feature/landing/presentation/screens/landing_screen.dart';
import 'package:flutter/material.dart';

import 'feature/game/presentation/screens/game_screen.dart';

final mainTextTheme = TextTheme(
  headline1: TextStyle(
    fontSize: 70.0,
    color: Colors.white,
    fontFamily: 'FiraSans',
  ),
  headline2: TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontFamily: 'FiraSans',
  ),
);

final providers = [];

class SchlangeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark();
    return MaterialApp(
      title: 'Schlange App',
      theme: theme.copyWith(
        textTheme: mainTextTheme,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: GameScreen.ID,
      routes: {
        GameScreen.ID: (context) => GameScreen(),
        LandingScreen.ID: (context) => LandingScreen(),
      },
    );
  }
}
