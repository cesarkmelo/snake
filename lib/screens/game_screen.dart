import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_game/widgets/controls.dart';
import 'package:snake_game/widgets/game_board.dart';
import 'package:snake_game/widgets/high_scores_dialog.dart';
import '../models/position.dart';
import '../models/high_score.dart';

import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<Position> snake;
  Position? food;
  Direction direction = Direction.right;
  Direction? nextDirection;
  bool isGameOver = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              setState(() {
                showHighScores = !showHighScores;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Tablero de juego
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Puntuación: $score',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      color: Colors.black12,
                      child:
                          isGameOver
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¡Juego Terminado!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: startGame,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                      ),
                                      child: const Text(
                                        'JUGAR DE NUEVO',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : GameBoard(
                                snake: snake,
                                food: food,
                                cellSize: 20,
                              ),
                    ),
                  ),
                ),
              ),
              Controls(
                onDirectionChanged: (newDirection) {
                  setState(() {
                    nextDirection = newDirection;
                  });
                },
                isGameOver: isGameOver,
              ),
            ],
          ),

          // Mostrar puntuaciones altas si está activo
          if (showHighScores)
            HighScoresDialog(
              highScores: highScores,
              onClose: () {
                setState(() {
                  showHighScores = false;
                });
              },
              onNewGame: () {
                setState(() {
                  showHighScores = false;
                  startGame();
                });
              },
            ),
        ],
      ),

    );
  }

  int score = 0;
  late Timer gameLoop;
  List<HighScore> highScores = [];
  bool showHighScores = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar el timer
    gameLoop = Timer(Duration.zero, () {});
    startGame();
    _loadHighScores();
  }

  @override
  void dispose() {
    // Cancelar el timer cuando el widget se destruya
    gameLoop.cancel();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList('high_scores') ?? [];
    setState(() {
      highScores =
          scoresJson
              .map((score) => HighScore.fromJson(jsonDecode(score)))
              .toList()
            ..sort((a, b) => b.score.compareTo(a.score));
    });
  }

  Future<void> _saveScore(String name) async {
    final newScore = HighScore(name: name, score: score, date: DateTime.now());

    final prefs = await SharedPreferences.getInstance();
    final scores = highScores.map((s) => jsonEncode(s.toJson())).toList();
    scores.add(jsonEncode(newScore.toJson()));

    // Mantener solo los 10 mejores puntajes
    scores.sort((a, b) {
      final scoreA = HighScore.fromJson(jsonDecode(a)).score;
      final scoreB = HighScore.fromJson(jsonDecode(b)).score;
      return scoreB.compareTo(scoreA);
    });

    final topScores = scores.take(10).toList();

    await prefs.setStringList('high_scores', topScores);
    await _loadHighScores();
  }

  void _showHighScores() {
    setState(() {
      showHighScores = true;
    });
  }

  void startGame() {
    // Cancelar el timer existente si hay uno
    if (gameLoop.isActive) {
      gameLoop.cancel();
    }

    setState(() {
      // Inicializar la serpiente en el centro del tablero
      final centerRow = (rowSize / 2).floor();
      final centerCol = (columnSize / 2).floor();
      snake = [
        Position(centerRow, centerCol),
        Position(centerRow, centerCol - 1),
      ];

      direction = Direction.right;
      nextDirection = null;
      isGameOver = false;
      score = 0;
      generateFood();
    });

    // Iniciar el bucle del juego
    gameLoop = Timer.periodic(
      const Duration(milliseconds: gameSpeed),
      (_) {
        if (mounted) {
          moveSnake();
        }
      },
    );
  }

  void generateFood() {
    // Generar comida en una posición aleatoria que no esté ocupada por la serpiente
    final random = Random();
    int maxAttempts = 100;
    int attempts = 0;

    while (attempts < maxAttempts) {
      final row = random.nextInt(rowSize);
      final col = random.nextInt(columnSize);

      if (!snake.any((pos) => pos.row == row && pos.col == col)) {
        setState(() {
          food = Position(row, col);
        });
        return;
      }
      attempts++;
    }

    // Si no se pudo encontrar una posición aleatoria, buscar secuencialmente
    for (int row = 0; row < rowSize; row++) {
      for (int col = 0; col < columnSize; col++) {
        if (!snake.any((pos) => pos.row == row && pos.col == col)) {
          setState(() {
            food = Position(row, col);
          });
          return;
        }
      }
    }

    // Si no hay espacio para comida, el jugador gana
    setState(() {
      isGameOver = true;
      _endGame();
    });
  }

  void _endGame() {
    setState(() {
      isGameOver = true;
    });

    // Solo mostrar diálogo de puntuación si el puntaje es mayor a 0
    if (score > 0 &&
        (highScores.length < 10 ||
            score > (highScores.lastOrNull?.score ?? 0))) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¡Nuevo récord!'),
            content: Text('Puntuación: $score\nIngresa tu nombre:'),
            actions: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Tu nombre'),
                textCapitalization: TextCapitalization.words,
              ),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    _saveScore(_nameController.text.trim());
                    _nameController.clear();
                    Navigator.of(context).pop();
                    _showHighScores();
                  }
                },
              ),
            ],
          );
        },
      );
    } else if (score > 0) {
      // Mostrar puntuaciones altas si el puntaje es mayor a 0 pero no es un récord
      _showHighScores();
    }
  }

  void moveSnake() {
    if (isGameOver) return;

    setState(() {
      // Aplicar la próxima dirección si hay una
      if (nextDirection != null) {
        // Evitar que la serpiente vaya en dirección opuesta
        if ((direction == Direction.up && nextDirection == Direction.down) ||
            (direction == Direction.down && nextDirection == Direction.up) ||
            (direction == Direction.left && nextDirection == Direction.right) ||
            (direction == Direction.right && nextDirection == Direction.left)) {
          nextDirection = null;
        } else {
          direction = nextDirection!;
          nextDirection = null;
        }
      }

      // Obtener la posición de la cabeza
      final head = snake.first;

      // Calcular la nueva posición de la cabeza
      int newRow = head.row;
      int newCol = head.col;

      switch (direction) {
        case Direction.up:
          newRow--;
          break;
        case Direction.down:
          newRow++;
          break;
        case Direction.left:
          newCol--;
          break;
        case Direction.right:
          newCol++;
          break;
      }

      // Verificar colisión con los bordes
      if (newRow < 0 ||
          newRow >= rowSize ||
          newCol < 0 ||
          newCol >= columnSize) {
        _endGame();
        return;
      }

      // Verificar colisión consigo misma
      if (snake.any((pos) => pos.row == newRow && pos.col == newCol)) {
        _endGame();
        return;
      }

      // Agregar nueva cabeza
      snake.insert(0, Position(newRow, newCol));

      // Verificar si comió la comida
      if (food != null && food!.row == newRow && food!.col == newCol) {
        score++;
        generateFood();
      } else {
        // Eliminar la cola si no comió
        snake.removeLast();
      }
    });
  }
}
