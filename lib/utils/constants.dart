import 'package:flutter/material.dart';

// Tamaño del tablero
const int rowSize = 20;
const int columnSize = 20;

// Velocidad del juego (milisegundos entre movimientos)
const int gameSpeed = 200;

// Colores
const Color backgroundColor = Color(0xFF121212); // Fondo oscuro
const Color scaffoldBgColor = Color(0xFF1E1E1E); // Color del scaffold
const Color snakeColor = Color(0xFF4CAF50); // Verde más suave
const Color foodColor = Color(0xFFFF5252); // Rojo vibrante
const Color gridColor = Color(0x1FFFFFFF); // Gris muy transparente
const Color borderColor = Color(0x33FFFFFF); // Borde sutil
const Color textColor = Colors.white;
const Color primaryColor = Color(0xFF2196F3); // Azul para botones
const Color disabledColor = Color(0xFF424242); // Gris para elementos deshabilitados

// Estilos de texto
const TextStyle scoreTextStyle = TextStyle(
  color: textColor,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

// Direcciones
enum Direction { up, down, left, right }
