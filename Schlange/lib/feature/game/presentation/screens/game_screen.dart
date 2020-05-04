import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../settings.dart';
import '../logicholders/game_change_notifier.dart';
import '../widgets/custom_buttons.dart';
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
              miniChild: MiniGameScreen(),
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
              Text('Schlange!', style: textTheme.headline1),
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

class MiniGameScreen extends StatelessWidget {
  const MiniGameScreen({
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
          height: 800.0,
          width: 500.0,
          child: Column(
            children: <Widget>[
              Spacer(flex: 3),
              SizedBox(height: 30.0),
              Text('Schlange!', style: textTheme.headline1),
              SizedBox(height: 20.0),
              InformationPanel(textTheme: textTheme),
              SizedBox(height: 15.0),
              GameBoard(),
              SizedBox(height: 20.0),
              ControlPanel(),
              Spacer(flex: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationPanel extends StatelessWidget {
  const InformationPanel({
    Key key,
    @required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: BLOCK_WIDTH * BOARD_WIDTH,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: BLOCK_WIDTH * BOARD_WIDTH / 2,
            child: ScoreDisplayer(textTheme: textTheme),
          ),
          ProgressDisplayer(textTheme: textTheme),
        ],
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    Key key,
  }) : super(key: key);

  final distance = 150.0;

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameChangeNotifier>(context, listen: false);
    return Stack(
      children: <Widget>[
        SizedBox(height: distance, width: distance),
        Positioned(
          top: 0.0,
          child: SizedBox(
            width: distance,
            child: ButtonUp(
              onPressed: () => game.currentDirection = Direction.up,
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: SizedBox(
            width: distance,
            child: ButtonDown(
              onPressed: () => game.currentDirection = Direction.down,
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          child: SizedBox(
            height: distance,
            child: ButtonLeft(
              onPressed: () => game.currentDirection = Direction.left,
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          child: SizedBox(
            height: distance,
            child: ButtonRight(
              onPressed: () => game.currentDirection = Direction.right,
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressDisplayer extends StatelessWidget {
  const ProgressDisplayer({
    Key key,
    @required this.textTheme,
    this.width,
  })  : assert(textTheme != null),
        super(key: key);

  final TextTheme textTheme;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
    this.width,
  })  : assert(textTheme != null),
        super(key: key);

  final TextTheme textTheme;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
