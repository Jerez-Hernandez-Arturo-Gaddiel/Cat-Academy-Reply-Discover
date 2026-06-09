import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/quiz_session_config.dart';
import '../../models/quiz_mode.dart';
import '../../providers/quiz_runner_provider.dart';

class QuizRunnerScreen extends StatefulWidget {
  final QuizSessionConfig config;
  const QuizRunnerScreen({super.key, required this.config});

  @override
  State<QuizRunnerScreen> createState() => _QuizRunnerScreenState();
}

class _QuizRunnerScreenState extends State<QuizRunnerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QuizRunnerProvider>().initialize(widget.config);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final runner = context.watch<QuizRunnerProvider>();
    
    if (runner.quiz == null || runner.quiz!.id != widget.config.quiz.id) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    final question = runner.currentQuestion;

    if (runner.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.pushReplacement('/results', extra: runner.getResult());
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (question == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.brown, size: 30),
                      onPressed: () => _confirmExit(context),
                    ),
                    Expanded(
                      child: Text(
                        runner.quiz?.title ?? 'Quiz',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.lightbulb, 
                            color: runner.hintUsed ? Colors.grey : Colors.orangeAccent, 
                            size: 30
                          ),
                          onPressed: runner.hintUsed ? null : () => runner.useHint(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.brown, size: 30),
                          onPressed: () => runner.speakQuestion(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: runner.progress,
                          minHeight: 10,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    if (runner.mode == QuizMode.timed) ...[
                      const SizedBox(width: 15),
                      Text(
                        '${runner.remainingSeconds}s',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: runner.remainingSeconds < 10 ? Colors.red : Colors.brown,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4B5).withOpacity(0.95), 
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pregunta ${runner.currentIndex + 1}/${runner.quiz!.questions.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      question.statement,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.brown,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ...List.generate(
                      question.options.length,
                      (index) => _OptionButton(index: index, runner: runner),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _confirmExit(context),
                      behavior: HitTestBehavior.opaque,
                      child: Image.asset('assets/images/Btn_Volver.png', width: 160),
                    ),
                    GestureDetector(
                      onTap: runner.selectedAnswerIndex != null ? () => runner.nextQuestion() : null,
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: runner.selectedAnswerIndex != null ? 1.0 : 0.5,
                        child: Image.asset('assets/images/Btn_Siguiente.png', width: 160),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFE4B5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Abandonar Michigan?', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        content: const Text('Tu progreso se perderá como un gato en la noche.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('SEGUIR', style: TextStyle(color: Colors.brown))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('SALIR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final int index;
  final QuizRunnerProvider runner;

  const _OptionButton({required this.index, required this.runner});

  @override
  Widget build(BuildContext context) {
    if (runner.hiddenOptions.contains(index)) {
      return const SizedBox.shrink(); 
    }

    final isSelected = runner.selectedAnswerIndex == index;
    final isCorrect = runner.currentQuestion!.correctAnswerIndex == index;
    
    Color backgroundColor = Colors.white.withOpacity(0.8);
    Color borderColor = Colors.orange.withOpacity(0.3);
    Color textColor = Colors.brown;

    if (runner.showImmediateFeedback) {
      if (isCorrect) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
      } else if (isSelected) {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = Colors.orange.shade100;
      borderColor = Colors.orange;
      textColor = Colors.orange.shade900;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => runner.selectAnswer(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Text(
                '${String.fromCharCode(65 + index)}.',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  runner.currentQuestion!.options[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: Colors.brown.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
