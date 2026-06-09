import 'package:flutter/material.dart';

class CatBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const CatBackground({
    super.key,
    required this.child,
    this.imagePath = 'assets/images/Fondo_Pagina.jpg',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
