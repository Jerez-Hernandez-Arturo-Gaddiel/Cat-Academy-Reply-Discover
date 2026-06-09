import 'package:flutter/material.dart';

class CatAcademyButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CatAcademyButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.width = 280.0,
    this.height = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          assetPath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
