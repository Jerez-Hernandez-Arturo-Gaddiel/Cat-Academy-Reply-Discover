import 'package:hive/hive.dart';
import 'question.dart';

part 'quiz.g.dart';

@HiveType(typeId: 0)
class Quiz extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  final DateTime createdAt;
  
  @HiveField(3)
  List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.questions,
  });
}
