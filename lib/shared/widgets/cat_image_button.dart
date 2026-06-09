import 'package:flutter/material.dart';

class CatImageButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const CatImageButton({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  State<CatImageButton> createState() => _CatImageButtonState();
}

class _CatImageButtonState extends State<CatImageButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double defaultWidth = MediaQuery.of(context).size.width * 0.7;
    final double finalWidth = widget.width ?? defaultWidth;
    final double finalHeight = widget.height ?? (finalWidth * 0.25);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: finalWidth,
          height: finalHeight,
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
