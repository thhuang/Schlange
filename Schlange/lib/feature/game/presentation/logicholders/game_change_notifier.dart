import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }
const DirectionHorizontal = {Direction.left, Direction.right};

enum BlockState { vacant, blocked, targeted, snake }

class GameChangeNotifier with ChangeNotifier {
  GameChangeNotifier({
    int initialLength = 5,
    int boardWidth = 30,
    int boardHeight = 30,
    int baseReward = 10,
    int rewardTimeFactor = 10,
    int rewardLengthFactor = 3,
    double blockWidth = 10.0,
    double blockHeight = 10.0,
  })  : assert(initialLength < boardWidth),
        assert(rewardTimeFactor > 0),
        _boardHeight = boardHeight,
        _boardWidth = boardWidth,
        _blockHeight = blockHeight,
        _blockWidth = blockWidth,
        _end = false,
        _startTime = DateTime.now(),
        _now = DateTime.now(),
        _score = 0,
        _baseReward = baseReward,
        _rewardTimeFactor = rewardTimeFactor,
        _rewardLengthFactor = rewardLengthFactor {
    // initiate the game board
    _gameBoardBlocks = <Coordinate, Block>{
      for (var i = 0; i < boardWidth; i++)
        for (var j = 0; j < boardHeight; j++)
          Coordinate(i, j): BlockVacant(
            height: _blockHeight,
            width: _blockWidth,
          ),
    };

    // initiate the snake
    _snake = LinkedList<SnakeNode>();
    _currentDirection = Direction.right;
    _nextDirection = Direction.right;
    var x = boardWidth ~/ 2;
    var y = boardHeight ~/ 2;
    for (var i = 0; i < initialLength; i++) {
      final coordinate = Coordinate(x-- % _boardWidth, y % _boardHeight);
      _snake.add(SnakeNode(coordinate));
      _gameBoardBlocks[coordinate] = BlockSnake(
        height: _blockHeight,
        width: _blockWidth,
      );
    }

    // generate the target
    _newTarget();

    // iterate
    iterate();
  }

  DateTime _startTime;
  DateTime _now;
  DateTime _lastTargetTime;
  int _score;
  int _baseReward;
  int _rewardTimeFactor;
  int _rewardLengthFactor;
  int _reward;
  LinkedList<SnakeNode> _snake;
  Direction _currentDirection;
  Direction _nextDirection;
  Coordinate _target;
  int _boardHeight;
  int _boardWidth;
  double _blockHeight;
  double _blockWidth;
  Map<Coordinate, Block> _gameBoardBlocks;
  bool _end;

  void iterate() {
    if (_end) return;

    _now = DateTime.now();
    updateGameBoard();
    updateReward();

    notifyListeners();
  }

  Coordinate _nextBlockCoordinate() {
    final head = _snakeHead;
    Coordinate nextBlockCoordinate;
    switch (_nextDirection) {
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
    _currentDirection = _nextDirection;
    return nextBlockCoordinate;
  }

  void updateGameBoard() {
    final nextBlockCoordinate = _nextBlockCoordinate();
    switch (_gameBoardBlocks[nextBlockCoordinate].state) {
      case BlockState.snake:
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

  void updateReward() {
    final targetSeconds = _now.difference(_lastTargetTime).inSeconds;
    final timeReward = _rewardTimeFactor ~/ max(1, targetSeconds);
    final lengthReward = _rewardLengthFactor * snakeLength;
    _reward = _baseReward + timeReward + lengthReward;
  }

  void _snakeLengthen(Coordinate newHead) {
    _gameBoardBlocks[newHead] = BlockSnake(
      height: _blockHeight,
      width: _blockWidth,
    );
    _snake.addFirst(SnakeNode(newHead));
    _score += _reward;
    _newTarget();
  }

  void _snakeMove(Coordinate newHead) {
    _gameBoardBlocks[newHead] = BlockSnake(
      height: _blockHeight,
      width: _blockWidth,
    );
    _gameBoardBlocks[_snake.last.coordinate] = BlockVacant(
      height: _blockHeight,
      width: _blockWidth,
    );
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
    _gameBoardBlocks[_target] = BlockTargeted(
      height: _blockHeight,
      width: _blockWidth,
    );
    _lastTargetTime = DateTime.now();
  }

  Coordinate get _snakeHead {
    return _snake.first.coordinate;
  }

  set currentDirection(Direction direction) {
    final validHorizontal = direction != _currentDirection &&
        DirectionHorizontal.contains(direction) !=
            DirectionHorizontal.contains(_currentDirection);
    if (!validHorizontal) {
      return;
    }
    _nextDirection = direction;
  }

  Block getBlock(Coordinate coordinate) {
    final ret = _gameBoardBlocks[coordinate];
    return ret == null ? Block(height: _blockHeight, width: _blockWidth) : ret;
  }

  int get boardHeight {
    return _boardHeight;
  }

  int get boardWidth {
    return _boardWidth;
  }

  String get durationString {
    final duration = _now.difference(_startTime);
    return duration.toString().split('.').first.padLeft(8, '0');
  }

  int get snakeLength {
    return _snake.length;
  }

  int get score {
    return _score;
  }

  int get reward {
    return _reward;
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
      case BlockState.snake:
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
        color = Colors.blue[100];
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

class BlockSnake extends Block {
  const BlockSnake({
    Key key,
    height = 10.0,
    width = 10.0,
  }) : super(
          key: key,
          state: BlockState.snake,
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
