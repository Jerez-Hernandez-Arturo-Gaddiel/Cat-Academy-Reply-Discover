class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final double percentage;
  final int score;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.percentage,
    required this.score,
  });
}
