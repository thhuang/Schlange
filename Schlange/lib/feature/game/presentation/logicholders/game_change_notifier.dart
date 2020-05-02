import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }
const DirectionHorizontal = {Direction.left, Direction.right};

enum BlockState { vacant, blocked, targeted, snack }

class GameChangeNotifier with ChangeNotifier {
  GameChangeNotifier({
    int initialLength = 5,
    int boardWidth = 30,
    int boardHeight = 30,
  })  : assert(initialLength < boardWidth),
        _boardWidth = boardWidth,
        _boardHeight = boardHeight,
        _end = false {
    // initiate the game board
    _gameBoardBlocks = <Coordinate, Block>{
      for (var i = 0; i < boardWidth; i++)
        for (var j = 0; j < boardHeight; j++) Coordinate(i, j): BlockVacant()
    };

    // initiate the snake
    _snake = LinkedList<SnakeNode>();
    _currentDirection = Direction.right;
    var x = boardWidth ~/ 2;
    var y = boardHeight ~/ 2;
    for (var i = 0; i < initialLength; i++) {
      final coordinate = Coordinate(x-- % _boardWidth, y % _boardHeight);
      _snake.add(SnakeNode(coordinate));
      _gameBoardBlocks[coordinate] = BlockSnack();
    }

    // generate the target
    _newTarget();
  }

  LinkedList<SnakeNode> _snake;
  Direction _currentDirection;
  Coordinate _target;
  int _boardHeight;
  int _boardWidth;
  Map<Coordinate, Block> _gameBoardBlocks;
  bool _end;

  void iterate() {
    if (_end) return;

    final head = _snakeHead;
    Coordinate nextBlockCoordinate;
    switch (_currentDirection) {
      case Direction.up:
        nextBlockCoordinate = Coordinate(
          head.x % _boardWidth,
          (head.y + 1) % _boardHeight,
        );
        break;
      case Direction.down:
        nextBlockCoordinate = Coordinate(
          head.x % _boardWidth,
          (head.y - 1) % _boardHeight,
        );
        break;
      case Direction.left:
        nextBlockCoordinate = Coordinate(
          (head.x - 1) % _boardWidth,
          head.y % _boardHeight,
        );
        break;
      case Direction.right:
      default:
        nextBlockCoordinate = Coordinate(
          (head.x + 1) % _boardWidth,
          head.y % _boardHeight,
        );
        break;
    }

    switch (_gameBoardBlocks[nextBlockCoordinate].state) {
      case BlockState.snack:
      case BlockState.blocked:
        _end = true;
        break;
      case BlockState.targeted:
        _snakeLengthen(nextBlockCoordinate);
        break;
      case BlockState.vacant:
      default:
        _snakeMove(nextBlockCoordinate);
        break;
    }
  }

  void _snakeLengthen(Coordinate newHead) {
    _gameBoardBlocks[newHead] = BlockSnack();
    _snake.addFirst(SnakeNode(newHead));
  }

  void _snakeMove(Coordinate newHead) {
    _gameBoardBlocks[newHead] = BlockSnack();
    _gameBoardBlocks[_snake.last.coordinate] = BlockVacant();
    _snake.addFirst(SnakeNode(newHead));
    _snake.last.unlink();
  }

  void _newTarget() {
    final random = Random();
    do {
      _target = Coordinate(
        random.nextInt(boardWidth),
        random.nextInt(boardHeight),
      );
    } while (_gameBoardBlocks[_target].state != BlockState.vacant);
    _gameBoardBlocks[_target] = BlockTargeted();
    _newTarget();
  }

  Coordinate get _snakeHead {
    return _snake.first.coordinate;
  }

  Coordinate get _snakeTail {
    return _snake.last.coordinate;
  }

  Direction get currentDirection {
    return _currentDirection;
  }

  set currentDirection(Direction direction) {
    final validHorizontal = direction != _currentDirection &&
        DirectionHorizontal.contains(direction) !=
            DirectionHorizontal.contains(_currentDirection);
    if (!validHorizontal) {
      return;
    }
    _currentDirection = direction;
    print(direction);
  }

  Block getBlock(Coordinate coordinate) {
    final ret = _gameBoardBlocks[coordinate];
    return ret == null ? Block() : ret;
  }

  int get boardHeight {
    return _boardHeight;
  }

  int get boardWidth {
    return _boardWidth;
  }
}

class SnakeNode extends LinkedListEntry<SnakeNode> {
  final Coordinate coordinate;

  SnakeNode(this.coordinate);

  @override
  String toString() => '$coordinate';
}

class Coordinate extends Equatable {
  Coordinate(this.x, this.y) : assert(x != null && y != null);

  final int x;
  final int y;

  @override
  String toString() => '($x, $y)';

  @override
  List<Object> get props => [x, y];
}

class Block extends StatelessWidget {
  const Block({
    Key key,
    this.state = BlockState.vacant,
    this.height = 10.0,
    this.width = 10.0,
  })  : assert(height != null),
        assert(width != null),
        super(key: key);

  final BlockState state;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (state) {
      case BlockState.snack:
        color = Colors.black87;
        break;
      case BlockState.targeted:
        color = Colors.red[400];
        break;
      case BlockState.blocked:
        color = Colors.indigo[900];
        break;
      case BlockState.vacant:
      default:
        color = Colors.lightBlue[100];
        break;
    }
    return Container(
      height: height,
      width: width,
      color: color,
    );
  }
}

class BlockVacant extends Block {
  const BlockVacant({
    Key key,
    height = 10.0,
    width = 10.0,
  }) : super(
          key: key,
          height: height,
          width: width,
        );
}

class BlockSnack extends Block {
  const BlockSnack({
    Key key,
    height = 10.0,
    width = 10.0,
  }) : super(
          key: key,
          state: BlockState.snack,
          height: height,
          width: width,
        );
}

class BlockTargeted extends Block {
  const BlockTargeted({
    Key key,
    height = 10.0,
    width = 10.0,
  }) : super(
          key: key,
          state: BlockState.targeted,
          height: height,
          width: width,
        );
}

class BlockBlocked extends Block {
  const BlockBlocked({
    Key key,
    height = 10.0,
    width = 10.0,
  }) : super(
          key: key,
          state: BlockState.blocked,
          height: height,
          width: width,
        );
}
