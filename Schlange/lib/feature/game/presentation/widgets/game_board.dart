import 'package:flutter/material.dart';

import '../../../../settings.dart';
import '../logicholders/game_change_notifier.dart';
import 'block.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BLOCK_HEIGHT * BOARD_HEIGHT,
      width: BLOCK_WIDTH * BOARD_WIDTH,
      color: boardColor,
      child: Column(
        children: <Widget>[
          for (var j = BOARD_HEIGHT - 1; j >= 0; j--)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var i = 0; i < BOARD_WIDTH; i++)
                  Block(
                    coordinate: Coordinate(i, j),
                    height: BLOCK_HEIGHT,
                    width: BLOCK_WIDTH,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
