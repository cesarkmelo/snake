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
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: scaffoldBgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1),
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
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: foodColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text('🍎', style: TextStyle(fontSize: cellSize * 0.7)),
                ),
              );
            }

            return Container(
              margin: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: isSnake ? snakeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: gridColor,
                  width: 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
