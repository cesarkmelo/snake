import 'package:flutter/material.dart';
import '../models/position.dart';
import '../utils/constants.dart';

class GameBoard extends StatelessWidget {
  final List<Position> snake;
  final Position? food;
  final double cellSize;

  const GameBoard({
    Key? key,
    required this.snake,
    required this.food,
    required this.cellSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize * columnSize,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnSize,
          childAspectRatio: 1.0,
        ),
        itemCount: rowSize * columnSize,
        itemBuilder: (context, index) {
          final row = index ~/ columnSize;
          final col = index % columnSize;

          final isSnake = snake.any((pos) => pos.row == row && pos.col == col);
          final isFood = food != null && food!.row == row && food!.col == col;

          if (isFood) {
            return Center(
              child: Text('🍎', style: TextStyle(fontSize: cellSize * 0.8)),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: isSnake ? snakeColor : backgroundColor,
              border: Border.all(color: gridColor),
            ),
          );
        },
      ),
    );
  }
}
