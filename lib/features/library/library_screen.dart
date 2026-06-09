import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/library_provider.dart';
import '../../shared/widgets/cat_background.dart';
import '../../models/quiz.dart';
import 'widgets/mode_selector_sheet.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Mi Biblioteca', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 28),
            onPressed: () {
              context.read<LibraryProvider>().resetAndSeed();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Biblioteca restablecida con 5 quizzes!')),
              );
            },
            tooltip: 'Restablecer Quizzes',
          ),
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 28),
            onPressed: () => context.go('/'),
            tooltip: 'Ir al Inicio',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CatBackground(
        imagePath: 'assets/images/Fondo_Biblioteca.png',
        child: SafeArea(
          child: Consumer<LibraryProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              if (provider.quizzes.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = provider.quizzes[index];
                  return _QuizCard(quiz: quiz);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/editor'),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('NUEVO QUIZ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 80, color: Colors.brown),
            const SizedBox(height: 16),
            const Text(
              'Aún no hay Quizzes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu biblioteca personal de cuestionarios aparecerá aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<LibraryProvider>().resetAndSeed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('¡CARGAR QUIZZES DE PRUEBA!', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final Quiz quiz;
  const _QuizCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            title: Text(
              quiz.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.brown),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${quiz.questions.length} preguntas'),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${quiz.createdAt.day}/${quiz.createdAt.month}/${quiz.createdAt.year}', 
                    style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.play_arrow_rounded,
                  label: 'Jugar',
                  color: Colors.green,
                  onTap: () => _showModeSelector(context),
                ),
                _buildActionButton(
                  icon: Icons.edit_rounded,
                  label: 'Editar',
                  color: Colors.blue,
                  onTap: () => context.push('/editor/${quiz.id}'),
                ),
                _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Borrar',
                  color: Colors.red,
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 20),
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  void _showModeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ModeSelectorSheet(quiz: quiz),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar Cuestionario?'),
        content: Text('Estás a punto de borrar "${quiz.title}". Esta acción es permanente.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
          ElevatedButton(
            onPressed: () {
              context.read<LibraryProvider>().deleteQuiz(quiz.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SÍ, ELIMINAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
