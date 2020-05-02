import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logicholders/game_change_notifier.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  // TODO: duration as a parameter
  final duration = Duration(milliseconds: 30);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      duration: duration,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Provider.of<GameChangeNotifier>(context, listen: false).iterate();
          _controller.reset();
          _controller.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameChangeNotifier>(builder: (context, game, _) {
      return Container(
        child: Column(
          children: <Widget>[
            for (var j = game.boardHeight - 1; j >= 0; j--)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (var i = 0; i < game.boardWidth; i++)
                    game.getBlock(Coordinate(i, j))
                ],
              ),
          ],
        ),
      );
    });
  }
}
