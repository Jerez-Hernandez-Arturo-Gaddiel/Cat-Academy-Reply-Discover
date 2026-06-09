import 'package:hive_flutter/hive_flutter.dart';
import '../../models/quiz.dart';
import '../../models/question.dart';

class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(QuizAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(QuestionAdapter());
    
    await Hive.openBox<Quiz>('quizzes_box');
  }
}
