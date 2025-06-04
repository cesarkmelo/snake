import 'package:flutter/material.dart';
import '../utils/constants.dart';

class Controls extends StatelessWidget {
  final Function(Direction) onDirectionChanged;
  final bool isGameOver;

  const Controls({
    Key? key,
    required this.onDirectionChanged,
    required this.isGameOver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Flecha arriba
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 36),
            color: Colors.white,
            onPressed:
                isGameOver ? null : () => onDirectionChanged(Direction.up),
          ),
          // Flechas izquierda y derecha
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 36),
                color: Colors.white,
                onPressed:
                    isGameOver
                        ? null
                        : () => onDirectionChanged(Direction.left),
              ),
              const SizedBox(width: 48), // Espacio entre botones
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 36),
                color: Colors.white,
                onPressed:
                    isGameOver
                        ? null
                        : () => onDirectionChanged(Direction.right),
              ),
            ],
          ),
          // Flecha abajo
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 36),
            color: Colors.white,
            onPressed:
                isGameOver ? null : () => onDirectionChanged(Direction.down),
          ),
        ],
      ),
    );
  }
}
