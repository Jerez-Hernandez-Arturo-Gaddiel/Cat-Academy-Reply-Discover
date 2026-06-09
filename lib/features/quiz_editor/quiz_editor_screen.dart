import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/quiz_editor_provider.dart';
import '../../providers/library_provider.dart';
import '../../models/quiz.dart';

class QuizEditorScreen extends StatefulWidget {
  final String? quizId;

  const QuizEditorScreen({super.key, this.quizId});

  @override
  State<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends State<QuizEditorScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final libraryProvider = context.read<LibraryProvider>();
      final editorProvider = context.read<QuizEditorProvider>();
      
      Quiz? existingQuiz;
      if (widget.quizId != null) {
        existingQuiz = libraryProvider.getQuizById(widget.quizId!);
      }
      
      editorProvider.initialize(existingQuiz);
      _titleController.text = editorProvider.title;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onSave() {
    final editor = context.read<QuizEditorProvider>();
    editor.setTitle(_titleController.text);

    if (!editor.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Miau! Completa el título y todas las preguntas.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final finalQuiz = editor.getFinalQuiz();
    context.read<LibraryProvider>().saveQuiz(finalQuiz).then((_) {
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
    final editor = context.watch<QuizEditorProvider>();

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.brown),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      widget.quizId == null ? 'Nuevo Michigan' : 'Editar Michigan',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4B5),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFFFB24A), width: 3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Título del Quiz'),
                        _buildOrangeTextField(_titleController, 'Ej: Razas de michis', (val) => editor.setTitle(val)),
                        
                        const SizedBox(height: 20),
                        const Divider(color: Colors.brown),
                        
                        ...List.generate(editor.questions.length, (index) {
                          return _QuestionFormBlock(index: index);
                        }),
                        
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => editor.addQuestion(),
                            icon: const Icon(Icons.add),
                            label: const Text('Añadir otra pregunta'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
    );
  }

  Widget _buildOrangeTextField(TextEditingController controller, String hint, Function(String)? onChanged) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFB24A), borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _QuestionFormBlock extends StatelessWidget {
  final int index;

  const _QuestionFormBlock({required this.index});

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<QuizEditorProvider>();
    final question = editor.questions[index];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pregunta ${index + 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
            if (editor.questions.length > 1)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => editor.removeQuestion(index),
              ),
          ],
        ),
        _buildOrangeField(
          initialValue: question.statement,
          hint: '¿Qué quieres preguntar?',
          onChanged: (val) => editor.updateQuestionStatement(index, val),
        ),
        const SizedBox(height: 10),
        const Text('Opciones (Selecciona la correcta)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown)),
        ...List.generate(4, (optIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: optIndex,
                  groupValue: question.correctAnswerIndex,
                  activeColor: Colors.brown,
                  onChanged: (val) => editor.setCorrectAnswer(index, val!),
                ),
                Expanded(
                  child: _buildOrangeField(
                    initialValue: question.options[optIndex],
                    hint: 'Opción ${String.fromCharCode(65 + optIndex)}',
                    onChanged: (val) => editor.updateOption(index, optIndex, val),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOrangeField({required String initialValue, required String hint, required Function(String) onChanged}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFB24A), borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
