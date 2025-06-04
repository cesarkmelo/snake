import 'package:flutter/material.dart';

// Tamaño del tablero
const int rowSize = 20;
const int columnSize = 20;

// Velocidad del juego (milisegundos entre movimientos)
const int gameSpeed = 200;

// Colores
const Color backgroundColor = Colors.black;
const Color snakeColor = Colors.green;
const Color gridColor = Colors.grey;
const Color borderColor = Colors.red;
const Color textColor = Colors.white;

// Estilos de texto
const TextStyle scoreTextStyle = TextStyle(
  color: textColor,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

// Direcciones
enum Direction { up, down, left, right }
