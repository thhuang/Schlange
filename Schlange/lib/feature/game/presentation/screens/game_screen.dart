import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/responsive_layout.dart';
import '../logicholders/game_change_notifier.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatelessWidget {
  static const String ID = '/game';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ChangeNotifierProvider<GameChangeNotifier>(
            create: (_) => GameChangeNotifier(),
            child: ResponsiveFocus(
              largeChild: LargeGameScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ResponsiveFocus extends StatefulWidget {
  const ResponsiveFocus({
    Key key,
    @required this.largeChild,
  })  : assert(largeChild != null),
        super(key: key);

  final Widget largeChild;

  @override
  _ResponsiveFocusState createState() => _ResponsiveFocusState();
}

class _ResponsiveFocusState extends State<ResponsiveFocus> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (FocusNode node, RawKeyEvent event) {
        if (event.runtimeType != RawKeyDownEvent) return false;

        final up = event.logicalKey == LogicalKeyboardKey.arrowUp;
        final down = event.logicalKey == LogicalKeyboardKey.arrowDown;
        final left = event.logicalKey == LogicalKeyboardKey.arrowLeft;
        final right = event.logicalKey == LogicalKeyboardKey.arrowRight;

        var game = Provider.of<GameChangeNotifier>(
          context,
          listen: false,
        );

        if (up) {
          game.currentDirection = Direction.up;
        } else if (down) {
          game.currentDirection = Direction.down;
        } else if (left) {
          game.currentDirection = Direction.left;
        } else if (right) {
          game.currentDirection = Direction.right;
        }

        return false;
      },
      child: ResponsiveLayout(
        largeChild: widget.largeChild,
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
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 100.0, bottom: 30.0),
            child: Text(
              'Schlange!',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          GameBoard(),
        ],
      ),
    );
  }
}
