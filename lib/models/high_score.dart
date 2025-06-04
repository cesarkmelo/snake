class HighScore {
  final String name;
  final int score;
  final DateTime date;

  HighScore({required this.name, required this.score, required this.date});

  Map<String, dynamic> toJson() => {
    'name': name,
    'score': score,
    'date': date.toIso8601String(),
  };

  factory HighScore.fromJson(Map<String, dynamic> json) => HighScore(
    name: json['name'],
    score: json['score'],
    date: DateTime.parse(json['date']),
  );
}
