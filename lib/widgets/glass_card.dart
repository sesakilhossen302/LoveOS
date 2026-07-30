import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? borderColor;
  final List<Color>? gradientColors;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 24.0,
    this.borderColor,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors ??
                    [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.03),
                    ],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? LoveTheme.cardBorderGlass,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
