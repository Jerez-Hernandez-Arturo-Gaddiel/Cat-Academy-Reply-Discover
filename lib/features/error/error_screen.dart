import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Esta página no existe o ha ocurrido un error.'),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
