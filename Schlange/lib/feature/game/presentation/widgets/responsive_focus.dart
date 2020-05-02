import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/responsive_layout.dart';
import '../logicholders/game_change_notifier.dart';

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
      onKey: onKeyPressed,
      child: ResponsiveLayout(
        largeChild: widget.largeChild,
      ),
    );
  }

  bool onKeyPressed(FocusNode node, RawKeyEvent event) {
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
