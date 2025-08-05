import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientContainer({
    Key? key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? (isDark 
            ? [
                const Color(0xFF2D1B69),
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
              ]
            : [
                const Color(0xFFE0CCE3), // Original lavender background
                const Color(0xFFF0E6FF),
                const Color(0xFFE8F5E8),
              ]),
        ),
      ),
      child: child,
    );
  }
}
