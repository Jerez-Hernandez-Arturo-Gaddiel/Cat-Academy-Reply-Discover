import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/quiz_result.dart';

class ResultsScreen extends StatelessWidget {
  final QuizResult result;

  const ResultsScreen({
    super.key, 
    required this.result,
  });

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
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4B5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFB24A), width: 5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, color: Color(0xFFD67300), size: 30),
                        SizedBox(width: 10),
                        Text(
                          '¡Puntaje Michi!',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD67300)),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.pets, color: Color(0xFFD67300), size: 30),
                      ],
                    ),
                    const SizedBox(height: 25),
                    
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD67300), width: 4),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                      ),
                      child: Center(
                        child: Text(
                          '${result.score}',
                          style: const TextStyle(fontSize: 75, fontWeight: FontWeight.w900, color: Color(0xFFE65100)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('puntos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54)),
                    
                    const SizedBox(height: 35),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBadge(Icons.check_circle, '${result.correctAnswers} Correctas', Colors.green),
                        _buildStatBadge(Icons.cancel, '${result.incorrectAnswers} Erradas', Colors.red),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    _buildResultButton(context, 'assets/images/Btn_inicio.png', '/'),
                    const SizedBox(height: 15),
                    _buildResultButton(context, 'assets/images/Btn_Biblioteca.png', '/library'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildResultButton(BuildContext context, String assetPath, String route) {
    return GestureDetector(
      onTap: () => context.go(route),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 240, 
        height: 65,
        child: Image.asset(assetPath, fit: BoxFit.fill),
      ),
    );
  }
}
