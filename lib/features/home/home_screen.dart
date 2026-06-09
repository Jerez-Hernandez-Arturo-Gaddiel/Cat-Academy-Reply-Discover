import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_runner_provider.dart';
import '../../shared/widgets/animated_cat_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: Column(
            children: [
              const Spacer(flex: 4), 
              
              AnimatedCatButton(
                assetPath: 'assets/images/btn_ComenzarQuiz.png',
                onTap: () {
                  context.read<QuizRunnerProvider>().reset();
                  context.go('/library');
                },
              ),
              const SizedBox(height: 20),
              
              AnimatedCatButton(
                assetPath: 'assets/images/btn_Biblioteca1.png',
                onTap: () => context.go('/library'),
              ),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
