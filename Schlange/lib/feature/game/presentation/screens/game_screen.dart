import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../settings.dart';
import '../logicholders/game_change_notifier.dart';
import '../widgets/game_board.dart';
import '../widgets/responsive_focus.dart';

class GameScreen extends StatelessWidget {
  static const String ID = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ChangeNotifierProvider<GameChangeNotifier>(
            create: (_) => GameChangeNotifier(
              boardHeight: BOARD_HEIGHT,
              boardWidth: BOARD_WIDTH,
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FittedBox(
        child: SizedBox(
          height: 700.0,
          width: 500.0,
          child: Column(
            children: <Widget>[
              Spacer(flex: 3),
              SizedBox(height: 30.0),
              Text(
                'Schlange!',
                style: textTheme.headline1,
              ),
              SizedBox(height: 15.0),
              ScoreDisplayer(textTheme: textTheme),
              SizedBox(height: 15.0),
              GameBoard(),
              SizedBox(height: 15.0),
              ProgressDisplayer(textTheme: textTheme),
              Spacer(flex: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressDisplayer extends StatelessWidget {
  const ProgressDisplayer({
    Key key,
    @required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class ScoreDisplayer extends StatelessWidget {
  const ScoreDisplayer({
    Key key,
    @required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
