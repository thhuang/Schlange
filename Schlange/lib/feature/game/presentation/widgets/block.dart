import 'package:Schlange/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logicholders/game_change_notifier.dart';

enum BlockState { vacant, blocked, targeted, snake }

class Block extends StatefulWidget {
  const Block({
    Key key,
    this.height = 10.0,
    this.width = 10.0,
    this.coordinate,
  })  : assert(height != null),
        assert(width != null),
        assert(coordinate != null),
        super(key: key);

  final Coordinate coordinate;
  final double height;
  final double width;

  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {
  var state;

  @override
  void initState() {
    super.initState();
    Provider.of<GameChangeNotifier>(
      context,
      listen: false,
    ).registerBlockCallback(widget.coordinate, (newState) {
      return setState(() => state = newState);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (state) {
      case BlockState.snake:
        color = snakeColor;
        break;
      case BlockState.targeted:
        color = targetColor;
        break;
      case BlockState.blocked:
        color = blockedColor;
        break;
      case BlockState.vacant:
      default:
        break;
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(decoration: BoxDecoration(color: color)),
    );
  }
}
