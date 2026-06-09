import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/persistence/hive_init.dart';
import 'providers/auth_provider.dart';
import 'providers/library_provider.dart';
import 'providers/quiz_editor_provider.dart';
import 'providers/quiz_runner_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  runApp(const CatAcademyApp());
}

class CatAcademyApp extends StatelessWidget {
  const CatAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => QuizEditorProvider()),
        ChangeNotifierProvider(create: (_) => QuizRunnerProvider()),
      ],
      builder: (context, child) {
        final authProvider = Provider.of<AuthProvider>(context);
        final router = AppRouter.createRouter(authProvider);

        return MaterialApp.router(
          title: 'Cat Academy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        );
      },
    );
  }
}
