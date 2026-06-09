import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quiz.dart';
import '../../../models/quiz_mode.dart';
import '../../../models/quiz_session_config.dart';

class ModeSelectorSheet extends StatelessWidget {
  final Quiz quiz;

  const ModeSelectorSheet({super.key, required this.quiz});

  void _startQuiz(BuildContext context, QuizMode mode) {
    final config = QuizSessionConfig(quiz: quiz, mode: mode);
    context.pop();
    context.push('/runner', extra: config);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Elige un modo para',
            style: TextStyle(fontSize: 14, color: Colors.grey[600], letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            quiz.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _ModeOption(
            title: 'Modo Normal',
            subtitle: 'Evaluación estándar sin ayudas.',
            icon: Icons.bolt,
            color: Colors.blue,
            onTap: () => _startQuiz(context, QuizMode.normal),
          ),
          const SizedBox(height: 16),
          _ModeOption(
            title: 'Modo Práctica',
            subtitle: 'Revisa si acertaste tras cada pregunta.',
            icon: Icons.school,
            color: Colors.green,
            onTap: () => _startQuiz(context, QuizMode.practice),
          ),
          const SizedBox(height: 16),
          _ModeOption(
            title: 'Contrarreloj',
            subtitle: '¡Responde rápido antes de que se agote el tiempo!',
            icon: Icons.timer,
            color: Colors.orange,
            onTap: () => _startQuiz(context, QuizMode.timed),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
