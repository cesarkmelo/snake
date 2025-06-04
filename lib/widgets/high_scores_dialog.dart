import 'package:flutter/material.dart';
import '../models/high_score.dart';

class HighScoresDialog extends StatelessWidget {
  final List<HighScore> highScores;
  final VoidCallback onNewGame;
  final VoidCallback onClose;

  const HighScoresDialog({
    Key? key,
    required this.highScores,
    required this.onNewGame,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mejores Puntuaciones', textAlign: TextAlign.center),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Pos')),
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Puntos')),
              DataColumn(label: Text('Fecha')),
            ],
            rows:
                highScores.asMap().entries.map((entry) {
                  final index = entry.key;
                  final score = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(score.name)),
                      DataCell(Text('${score.score}')),
                      DataCell(
                        Text(
                          '${score.date.day}/${score.date.month}/${score.date.year}',
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(child: const Text('Cerrar'), onPressed: onClose),
        TextButton(child: const Text('Nuevo Juego'), onPressed: onNewGame),
      ],
    );
  }
}
