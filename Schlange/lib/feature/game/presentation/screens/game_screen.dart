import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logicholders/game_change_notifier.dart';
import '../widgets/game_board.dart';
import '../widgets/responsive_focus.dart';

class GameScreen extends StatelessWidget {
  static const String ID = '/game';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ChangeNotifierProvider<GameChangeNotifier>(
            create: (_) => GameChangeNotifier(
              boardHeight: 30,
              boardWidth: 30,
            ),
            child: ResponsiveFocus(
              largeChild: LargeGameScreen(),
            ),
          );
        },
      ),
    );
  }
}

class LargeGameScreen extends StatelessWidget {
  const LargeGameScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: <Widget>[
          Spacer(flex: 3),
          SizedBox(height: 30.0),
          Text(
            'Schlange!',
            style: textTheme.headline1,
          ),
          SizedBox(height: 10.0),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Score: ${Provider.of<GameChangeNotifier>(context).score}',
                  style: textTheme.headline2,
                ),
                Text(
                  'Reward: ${Provider.of<GameChangeNotifier>(context).reward}',
                  style: textTheme.headline2,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          GameBoard(),
          SizedBox(height: 10.0),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Duration: ${Provider.of<GameChangeNotifier>(context).durationString}',
                  style: textTheme.headline2,
                ),
                Text(
                  'Snake Length: ${Provider.of<GameChangeNotifier>(context).snakeLength}',
                  style: textTheme.headline2,
                ),
              ],
            ),
          ),
          Spacer(flex: 10),
        ],
      ),
    );
  }
}
