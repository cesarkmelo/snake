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

  Widget _buildDirectionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required double size,
    Color? backgroundColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: size * 0.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = 60.0; // Tamaño de los botones
    final buttonSpacing = 12.0; // Espaciado entre botones

    return Container(
      padding: const EdgeInsets.only(top: 24.0, bottom: 40.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.2),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila superior (flecha arriba)
          _buildDirectionButton(
            icon: Icons.arrow_upward,
            onPressed: isGameOver ? null : () => onDirectionChanged(Direction.up),
            size: buttonSize,
            backgroundColor: isGameOver ? Colors.grey[600] : Colors.blue[700],
          ),
          
          // Fila media (flechas izquierda y derecha)
          Padding(
            padding: EdgeInsets.symmetric(vertical: buttonSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDirectionButton(
                  icon: Icons.arrow_back,
                  onPressed: isGameOver 
                      ? null 
                      : () => onDirectionChanged(Direction.left),
                  size: buttonSize,
                  backgroundColor: isGameOver ? Colors.grey[600] : Colors.blue[700],
                ),
                SizedBox(width: buttonSize + buttonSpacing * 2), // Espacio para el botón central
                _buildDirectionButton(
                  icon: Icons.arrow_forward,
                  onPressed: isGameOver 
                      ? null 
                      : () => onDirectionChanged(Direction.right),
                  size: buttonSize,
                  backgroundColor: isGameOver ? Colors.grey[600] : Colors.blue[700],
                ),
              ],
            ),
          ),
          
          // Fila inferior (flecha abajo)
          _buildDirectionButton(
            icon: Icons.arrow_downward,
            onPressed: isGameOver ? null : () => onDirectionChanged(Direction.down),
            size: buttonSize,
            backgroundColor: isGameOver ? Colors.grey[600] : Colors.blue[700],
          ),
          
          // Espacio adicional en la parte inferior para mejor accesibilidad
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
