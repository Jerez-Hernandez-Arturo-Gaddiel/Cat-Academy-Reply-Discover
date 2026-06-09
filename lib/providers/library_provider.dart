import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class LibraryProvider extends ChangeNotifier {
  static const String _boxName = 'quizzes_box';
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  final _uuid = const Uuid();

  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;

  LibraryProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<Quiz>(_boxName);
      }
      final box = Hive.box<Quiz>(_boxName);

      bool hasBaseQuizzes = box.containsKey('quiz_seed_1') && 
                            box.containsKey('quiz_seed_2') &&
                            box.containsKey('quiz_seed_3') &&
                            box.containsKey('quiz_seed_4') &&
                            box.containsKey('quiz_seed_5');

      if (!hasBaseQuizzes) {
        await seedPredefinedQuizzes();
      }

      _loadData(box);
    } catch (e) {
      debugPrint('CatAcademy Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadData(Box<Quiz> box) {
    _quizzes = box.values.toList();
    _quizzes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addQuiz(Quiz quiz) async {
    final box = Hive.box<Quiz>(_boxName);
    await box.put(quiz.id, quiz);
    _loadData(box);
    notifyListeners();
  }

  Future<void> editQuiz(Quiz quiz) async {
    final box = Hive.box<Quiz>(_boxName);
    await box.put(quiz.id, quiz);
    _loadData(box);
    notifyListeners();
  }

  Future<void> saveQuiz(Quiz quiz) async {
    final box = Hive.box<Quiz>(_boxName);
    await box.put(quiz.id, quiz);
    _loadData(box);
    notifyListeners();
  }

  Future<void> deleteQuiz(String id) async {
    final box = Hive.box<Quiz>(_boxName);
    await box.delete(id);
    _loadData(box);
    notifyListeners();
  }

  Future<void> resetAndSeed() async {
    _isLoading = true;
    notifyListeners();
    
    final box = Hive.box<Quiz>(_boxName);
    await box.clear();
    await seedPredefinedQuizzes();
    
    _loadData(box);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> seedPredefinedQuizzes() async {
    final box = Hive.box<Quiz>(_boxName);
    final List<Quiz> predefined = [
      Quiz(
        id: 'quiz_seed_1',
        title: 'Cultura General del Mundo',
        createdAt: DateTime.now(),
        questions: [
          Question(id: _uuid.v4(), statement: '¿Cuál es el río más largo del mundo?', options: ['Nilo', 'Amazonas', 'Misisipi', 'Yangtsé'], correctAnswerIndex: 1),
          Question(id: _uuid.v4(), statement: '¿En qué continente está Egipto?', options: ['Asia', 'Europa', 'África', 'Oceanía'], correctAnswerIndex: 2),
          Question(id: _uuid.v4(), statement: '¿Qué país tiene forma de bota?', options: ['España', 'Francia', 'Grecia', 'Italia'], correctAnswerIndex: 3),
        ],
      ),
      Quiz(
        id: 'quiz_seed_2',
        title: 'El Mundo de los Gatos',
        createdAt: DateTime.now().subtract(const Duration(seconds: 1)),
        questions: [
          Question(id: _uuid.v4(), statement: '¿Cuántas horas duerme un gato al día?', options: ['8-10h', '12-16h', '4-6h', '20-22h'], correctAnswerIndex: 1),
          Question(id: _uuid.v4(), statement: '¿Qué sentido tienen más desarrollado?', options: ['Gusto', 'Vista', 'Oído', 'Tacto'], correctAnswerIndex: 2),
          Question(id: _uuid.v4(), statement: '¿Cómo nos saludan principalmente?', options: ['Maullidos', 'Ronroneos', 'Cola arriba', 'Parpadeo lento'], correctAnswerIndex: 0),
        ],
      ),
      Quiz(
        id: 'quiz_seed_3',
        title: 'Historia Universal',
        createdAt: DateTime.now().subtract(const Duration(seconds: 2)),
        questions: [
          Question(id: _uuid.v4(), statement: '¿Año del descubrimiento de América?', options: ['1492', '1789', '1500', '1453'], correctAnswerIndex: 0),
          Question(id: _uuid.v4(), statement: '¿Quién pintó la Mona Lisa?', options: ['Miguel Ángel', 'Van Gogh', 'Da Vinci', 'Picasso'], correctAnswerIndex: 2),
          Question(id: _uuid.v4(), statement: '¿Capital del Imperio Inca?', options: ['Lima', 'Cuzco', 'Machu Picchu', 'Quito'], correctAnswerIndex: 1),
        ],
      ),
      Quiz(
        id: 'quiz_seed_4',
        title: 'Ciencia y Naturaleza',
        createdAt: DateTime.now().subtract(const Duration(seconds: 3)),
        questions: [
          Question(id: _uuid.v4(), statement: '¿Símbolo químico del agua?', options: ['Ag', 'H2O', 'O2', 'CO2'], correctAnswerIndex: 1),
          Question(id: _uuid.v4(), statement: '¿Planeta más grande?', options: ['Tierra', 'Marte', 'Saturno', 'Júpiter'], correctAnswerIndex: 3),
          Question(id: _uuid.v4(), statement: '¿Órgano que bombea la sangre?', options: ['Pulmones', 'Cerebro', 'Hígado', 'Corazón'], correctAnswerIndex: 3),
        ],
      ),
      Quiz(
        id: 'quiz_seed_5',
        title: 'Ortografía y Gramática',
        createdAt: DateTime.now().subtract(const Duration(seconds: 4)),
        questions: [
          Question(id: _uuid.v4(), statement: '¿Forma correcta: lugar lejano?', options: ['Halla', 'Haya', 'Allá', 'Aya'], correctAnswerIndex: 2),
          Question(id: _uuid.v4(), statement: '¿Qué palabra lleva tilde?', options: ['Examen', 'Canción', 'Imagen', 'Dintel'], correctAnswerIndex: 1),
          Question(id: _uuid.v4(), statement: '¿Pasado del verbo "Hacer"?', options: ['Hizo', 'Hiso', 'Izo', 'Iso'], correctAnswerIndex: 0),
        ],
      ),
    ];

    for (var quiz in predefined) {
      await box.put(quiz.id, quiz);
    }
  }

  Quiz? getQuizById(String id) {
    try {
      return _quizzes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }
}
