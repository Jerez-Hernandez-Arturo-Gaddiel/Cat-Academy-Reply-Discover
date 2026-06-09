import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizEditorProvider extends ChangeNotifier {
  final Uuid _uuid = const Uuid();

  String _title = '';
  List<Question> _questions = [];
  String? _editingQuizId;
  DateTime? _createdAt;

  String get title => _title;
  List<Question> get questions => _questions;
  bool get isEditing => _editingQuizId != null;

  void initialize(Quiz? quiz) {
    if (quiz != null) {
      _editingQuizId = quiz.id;
      _title = quiz.title;
      _createdAt = quiz.createdAt;
      _questions = quiz.questions.map((q) => Question(
        id: q.id,
        statement: q.statement,
        options: List.from(q.options),
        correctAnswerIndex: q.correctAnswerIndex,
      )).toList();
    } else {
      _reset();
      addQuestion(); 
    }
    notifyListeners();
  }

  void _reset() {
    _editingQuizId = null;
    _title = '';
    _questions = [];
    _createdAt = DateTime.now();
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void addQuestion() {
    _questions.add(Question(
      id: _uuid.v4(),
      statement: '',
      options: ['', '', '', ''],
      correctAnswerIndex: 0,
    ));
    notifyListeners();
  }

  void removeQuestion(int index) {
    if (_questions.length > 1) {
      _questions.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuestionStatement(int index, String statement) {
    _questions[index].statement = statement;
    notifyListeners();
  }

  void updateOption(int questionIndex, int optionIndex, String text) {
    _questions[questionIndex].options[optionIndex] = text;
    notifyListeners();
  }

  void setCorrectAnswer(int questionIndex, int optionIndex) {
    _questions[questionIndex].correctAnswerIndex = optionIndex;
    notifyListeners();
  }

  bool get isValid {
    if (_title.trim().isEmpty) return false;
    if (_questions.isEmpty) return false;

    for (var q in _questions) {
      if (q.statement.trim().isEmpty) return false;
      if (q.options.any((opt) => opt.trim().isEmpty)) return false;
    }
    return true;
  }

  Quiz getFinalQuiz() {
    return Quiz(
      id: _editingQuizId ?? _uuid.v4(),
      title: _title.trim(),
      createdAt: _createdAt ?? DateTime.now(),
      questions: _questions,
    );
  }
}
