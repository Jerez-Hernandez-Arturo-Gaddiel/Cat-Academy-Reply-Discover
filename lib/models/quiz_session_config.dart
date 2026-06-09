import 'quiz.dart';
import 'quiz_mode.dart';

class QuizSessionConfig {
  final Quiz quiz;
  final QuizMode mode;

  QuizSessionConfig({
    required this.quiz,
    required this.mode,
  });
}
