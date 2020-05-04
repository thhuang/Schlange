import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/responsive_layout.dart';
import '../logicholders/game_change_notifier.dart';

class ResponsiveFocus extends StatefulWidget {
  const ResponsiveFocus({
    Key key,
    @required this.largeChild,
    @required this.miniChild,
  })  : assert(largeChild != null),
        assert(miniChild != null),
        super(key: key);

  final Widget largeChild;
  final Widget miniChild;

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
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKey: _onKeyPressed,
        child: ResponsiveLayout(
          largeChild: widget.largeChild,
          miniChild: widget.miniChild,
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails detail) {
    final up = detail.delta.dy < -13.0;
    final down = detail.delta.dy > 13.0;
    final left = detail.delta.dx < -13.0;
    final right = detail.delta.dx > 13.0;

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
  }

  bool _onKeyPressed(FocusNode node, RawKeyEvent event) {
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
  }
}
