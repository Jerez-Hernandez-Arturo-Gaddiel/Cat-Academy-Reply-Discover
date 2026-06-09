import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final user = _userController.text;
    final password = _passwordController.text;

    if (user.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tus credenciales')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await context.read<AuthProvider>().login(user, password);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.go('/library'); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas. Intenta de nuevo.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 300.0), 
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4B5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.orange, blurRadius: 10)],
                          ),
                        ),
                        const SizedBox(height: 35),
                        
                        _buildCustomTextField('Nombre de usuario:', controller: _userController),
                        const SizedBox(height: 25),
                        _buildCustomTextField('Contraseña:', isObscure: true, controller: _passwordController),
                        
                        const SizedBox(height: 50),
                        
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: CircularProgressIndicator(color: Colors.orange),
                          ),

                        Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _isLoading ? null : _login,
                            child: Image.asset('assets/images/btn_IniciarSesion.png', width: 180),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField(String label, {bool isObscure = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFFB24A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
