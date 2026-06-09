import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/quiz.dart';
import '../models/question.dart';
import '../models/quiz_mode.dart';
import '../models/quiz_session_config.dart';
import '../models/quiz_result.dart';

class QuizRunnerProvider extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  
  Quiz? _quiz;
  QuizMode? _mode;
  
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  bool _isFinished = false;
  
  Timer? _timer;
  int _remainingSeconds = 0;
  static const int _secondsPerQuestion = 15;

  bool _showImmediateFeedback = false;
  bool? _lastAnswerWasCorrect;

  bool _hintUsed = false;
  List<int> _hiddenOptions = [];

  Quiz? get quiz => _quiz;
  QuizMode? get mode => _mode;
  int get currentIndex => _currentIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  bool get isFinished => _isFinished;
  int get remainingSeconds => _remainingSeconds;
  bool get showImmediateFeedback => _showImmediateFeedback;
  bool? get lastAnswerWasCorrect => _lastAnswerWasCorrect;
  bool get hintUsed => _hintUsed;
  List<int> get hiddenOptions => _hiddenOptions;
  
  Question? get currentQuestion => (_quiz != null && _currentIndex < _quiz!.questions.length) 
      ? _quiz!.questions[_currentIndex] 
      : null;

  double get progress => _quiz != null ? (_currentIndex + 1) / _quiz!.questions.length : 0;

  void reset() {
    _quiz = null;
    _mode = null;
    _currentIndex = 0;
    _selectedAnswerIndex = null;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _isFinished = false;
    _showImmediateFeedback = false;
    _lastAnswerWasCorrect = null;
    _remainingSeconds = 0;
    _hintUsed = false;
    _hiddenOptions = [];
    _timer?.cancel();
    notifyListeners();
  }

  void initialize(QuizSessionConfig config) {
    _timer?.cancel();
    _quiz = null;
    _mode = null;
    _currentIndex = 0;
    _selectedAnswerIndex = null;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _isFinished = false;
    _showImmediateFeedback = false;
    _lastAnswerWasCorrect = null;
    _remainingSeconds = 0;
    _hintUsed = false;
    _hiddenOptions = [];
    
    _quiz = config.quiz;
    _mode = config.mode;

    if (_mode == QuizMode.timed) {
      _remainingSeconds = _quiz!.questions.length * _secondsPerQuestion;
      _startTimer();
    }
    
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _finishQuiz();
      }
    });
  }

  void useHint() {
    if (_hintUsed || _isFinished || currentQuestion == null) return;
    
    final correctIndex = currentQuestion!.correctAnswerIndex;
    final List<int> wrongIndices = [];
    for (int i = 0; i < 4; i++) {
      if (i != correctIndex) wrongIndices.add(i);
    }
    
    wrongIndices.shuffle();
    _hiddenOptions = [wrongIndices[0], wrongIndices[1]];
    _hintUsed = true;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_isFinished) return;
    if (_hiddenOptions.contains(index)) return; 
    
    if (_mode == QuizMode.practice && _showImmediateFeedback) return;

    _selectedAnswerIndex = index;
    
    if (_mode == QuizMode.practice) {
      _showImmediateFeedback = true;
      _lastAnswerWasCorrect = (index == currentQuestion!.correctAnswerIndex);
      if (_lastAnswerWasCorrect!) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
    }
    
    notifyListeners();
  }

  void nextQuestion() {
    if (_quiz == null || _isFinished) return;

    if (_mode != QuizMode.practice) {
      if (_selectedAnswerIndex == currentQuestion?.correctAnswerIndex) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
    }

    if (_currentIndex < _quiz!.questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      _showImmediateFeedback = false;
      _lastAnswerWasCorrect = null;
      _hintUsed = false; 
      _hiddenOptions = [];
    } else {
      _finishQuiz();
    }
    notifyListeners();
  }

  void _finishQuiz() {
    if (_isFinished) return;
    
    _isFinished = true;
    _timer?.cancel();
    notifyListeners();
  }

  Future<void> speakQuestion() async {
    if (currentQuestion != null) {
      await _flutterTts.setLanguage("es-MX"); 
      await _flutterTts.setPitch(1.0);
      
      String textToSpeak = "Pregunta: ${currentQuestion!.statement}. ";
      textToSpeak += "Las opciones son: ";
      for (int i = 0; i < currentQuestion!.options.length; i++) {
        if (!_hiddenOptions.contains(i)) {
          textToSpeak += "${String.fromCharCode(65 + i)}, ${currentQuestion!.options[i]}. ";
        }
      }
      
      await _flutterTts.speak(textToSpeak);
    }
  }

  QuizResult getResult() {
    final total = _quiz?.questions.length ?? 0;
    final percentage = total > 0 ? (_correctAnswers / total) * 100 : 0.0;
    final score = total > 0 ? ((_correctAnswers / total) * 10).round() : 0;

    return QuizResult(
      totalQuestions: total,
      correctAnswers: _correctAnswers,
      incorrectAnswers: total - _correctAnswers,
      percentage: percentage,
      score: score,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}
