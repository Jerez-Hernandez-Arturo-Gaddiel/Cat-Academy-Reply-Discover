import 'package:hive/hive.dart';

part 'question.g.dart';

@HiveType(typeId: 1)
class Question extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String statement;
  
  @HiveField(2)
  List<String> options;
  
  @HiveField(3)
  int correctAnswerIndex;

  Question({
    required this.id,
    required this.statement,
    required this.options,
    required this.correctAnswerIndex,
  }) : assert(options.length == 4);
}
