import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../settings.dart';
import '../widgets/block.dart';

enum Direction { up, down, left, right }
const DirectionHorizontal = {Direction.left, Direction.right};

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
        _baseReward = baseReward,
        _rewardTimeFactor = rewardTimeFactor,
        _rewardLengthFactor = rewardLengthFactor {
    // initiate the game board
    _gameBoardBlockStates = <Coordinate, BlockState>{
      for (var i = 0; i < boardWidth; i++)
        for (var j = 0; j < boardHeight; j++)
          Coordinate(i, j): BlockState.vacant
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
      _gameBoardBlockStates[coordinate] = BlockState.snake;
    }

    // generate the target
    _newTarget();

    // loop
    loop();
  }

  DateTime _startTime = DateTime.now();
  DateTime _now = DateTime.now();
  DateTime _lastTargetTime;
  int _score = 0;
  int _baseReward;
  int _rewardTimeFactor;
  int _rewardLengthFactor;
  int _reward = 0;
  LinkedList<SnakeNode> _snake;
  Direction _currentDirection;
  Direction _nextDirection;
  Coordinate _target;
  int _boardHeight;
  int _boardWidth;
  Map<Coordinate, BlockState> _gameBoardBlockStates;
  Map<Coordinate, void Function(BlockState)> _blockCallbacks = {};
  bool _end = false;

  Future<void> loop() async {
    do {
      iterate();
      await Future.delayed(Duration(milliseconds: 1000 ~/ FREQUENCY));
    } while (!_end);
  }

  void iterate() {
    if (_end) return;

    _now = DateTime.now();
    updateGameBoard();
    updateReward();
    notifyListeners();
  }

  void registerBlockCallback(
    Coordinate coordinate,
    void Function(BlockState) callback,
  ) {
    _blockCallbacks[coordinate] = callback;
    callback(_gameBoardBlockStates[coordinate]);
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
    switch (_gameBoardBlockStates[nextBlockCoordinate]) {
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
    _gameBoardBlockStates[newHead] = BlockState.snake;
    _snake.addFirst(SnakeNode(newHead));
    if (_blockCallbacks[newHead] != null)
      _blockCallbacks[newHead](_gameBoardBlockStates[newHead]);

    _score += _reward;

    _newTarget();
  }

  void _snakeMove(Coordinate newHead) {
    _gameBoardBlockStates[newHead] = BlockState.snake;
    _snake.addFirst(SnakeNode(newHead));
    if (_blockCallbacks[newHead] != null)
      _blockCallbacks[newHead](_gameBoardBlockStates[newHead]);

    final tail = _snake.last;
    _gameBoardBlockStates[tail.coordinate] = BlockState.vacant;
    if (_blockCallbacks[_snake.last.coordinate] != null)
      _blockCallbacks[tail.coordinate](_gameBoardBlockStates[tail.coordinate]);

    tail.unlink();
  }

  void _newTarget() {
    final random = Random();
    do {
      _target = Coordinate(
        random.nextInt(boardWidth),
        random.nextInt(boardHeight),
      );
    } while (_gameBoardBlockStates[_target] != BlockState.vacant);
    _gameBoardBlockStates[_target] = BlockState.targeted;
    if (_blockCallbacks[_snake.last.coordinate] != null)
      _blockCallbacks[_target](_gameBoardBlockStates[_target]);
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

  BlockState getBlockState(Coordinate coordinate) {
    final ret = _gameBoardBlockStates[coordinate];
    return ret == null ? BlockState.vacant : ret;
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

  void stop() {
    _end = true;
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
