import 'package:Schlange/core/presentation/responsive_layout.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  static const String ID = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ResponsiveLayout(
            largeChild: Center(
              child: Text(
                'Schlange',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          );
        },
      ),
    );
  }
}
