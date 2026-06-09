import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../providers/library_provider.dart';
import '../../models/quiz.dart';
import '../../models/question.dart';

class QuizEditorScreen extends StatefulWidget {
  final String? quizId;

  const QuizEditorScreen({super.key, this.quizId});

  @override
  State<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends State<QuizEditorScreen> {
  final _uuid = const Uuid();
  late TextEditingController _titleController;
  final List<TextEditingController> _questionControllers = [
    TextEditingController(), 
    TextEditingController(), 
    TextEditingController(), 
    TextEditingController(), 
    TextEditingController(), 
  ];
  int _correctAnswerIndex = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    final questionText = _questionControllers[0].text.trim();
    final options = _questionControllers.skip(1).map((c) => c.text.trim()).toList();

    if (title.isEmpty || questionText.isEmpty || options.any((o) => o.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Miau! Por favor rellena todos los campos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newQuestion = Question(
      id: _uuid.v4(),
      statement: questionText,
      options: options,
      correctAnswerIndex: _correctAnswerIndex,
    );

    final newQuiz = Quiz(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
      questions: [newQuestion],
    );

    context.read<LibraryProvider>().saveQuiz(newQuiz).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Cuestionario guardado con éxito!')),
        );
        context.go('/library');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Fondo_Pagina.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4B5), 
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFB24A), width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Nuevo Cuestionario',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    _buildSectionTitle('Título del Quiz'),
                    _buildOrangeTextField(_titleController, 'Ej: Razas de michis'),
                    
                    const SizedBox(height: 20),
                    _buildSectionTitle('Agrega una pregunta'),
                    _buildOrangeTextField(_questionControllers[0], '¿Qué quieres preguntar?'),
                    
                    const SizedBox(height: 20),
                    _buildSectionTitle('Respuestas'),
                    ...List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: _correctAnswerIndex,
                              activeColor: Colors.brown,
                              onChanged: (val) {
                                setState(() => _correctAnswerIndex = val!);
                              },
                            ),
                            Expanded(
                              child: _buildOrangeTextField(
                                _questionControllers[index + 1], 
                                'Opción ${String.fromCharCode(65 + index)}'
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 30),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Image.asset('assets/images/Btn_Cancelar.png', width: 120),
                        ),
                        GestureDetector(
                          onTap: _onSave,
                          child: Image.asset('assets/images/Btn_Guardar.png', width: 120),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }

  Widget _buildOrangeTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFB24A),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
