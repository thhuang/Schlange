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
  final duration = Duration(milliseconds: 100);
  var displacement = 0.0;
  var shouldIterate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0.0,
      duration: duration,
    )
      ..addListener(() => setState(() => displacement = _controller.value))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => shouldIterate = true);
          _controller.reset();
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
    if (shouldIterate) {
      setState(() => shouldIterate = false);
      _controller.forward();
      Provider.of<GameChangeNotifier>(context, listen: false).iterate();
    }
    return Consumer<GameChangeNotifier>(builder: (context, game, _) {
      return Container(
        child: Column(
          children: <Widget>[
            for (var j = 0; j < game.boardHeight; j++)
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
