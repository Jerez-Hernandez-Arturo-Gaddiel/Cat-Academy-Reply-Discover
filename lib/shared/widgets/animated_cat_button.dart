import 'package:flutter/material.dart';

class AnimatedCatButton extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;
  final VoidCallback onTap;

  const AnimatedCatButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.width = 280,
    this.height = 75,
  });

  @override
  State<AnimatedCatButton> createState() => _AnimatedCatButtonState();
}

class _AnimatedCatButtonState extends State<AnimatedCatButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Image.asset(
            widget.assetPath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
