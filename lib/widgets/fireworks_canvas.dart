import 'dart:math';
import 'package:flutter/material.dart';

class FireworksCanvas extends StatefulWidget {
  final Widget child;

  const FireworksCanvas({super.key, required this.child});

  @override
  State<FireworksCanvas> createState() => _FireworksCanvasState();
}

class _FireworksCanvasState extends State<FireworksCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FireworkSpark> _sparks = [];
  final Random _random = Random();

  final List<Color> _sparkColors = const [
    Color(0xFFFF2A6D),
    Color(0xFFFF7597),
    Color(0xFFFFD700),
    Color(0xFF00F5D4),
    Color(0xFF9D4EDD),
    Color(0xFFFFFFFF),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _addFirework(Offset pos) {
    setState(() {
      for (int i = 0; i < 30; i++) {
        double angle = _random.nextDouble() * 2 * pi;
        double speed = _random.nextDouble() * 5 + 2;
        _sparks.add(_FireworkSpark(
          x: pos.dx,
          y: pos.dy,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          color: _sparkColors[_random.nextInt(_sparkColors.length)],
          size: _random.nextDouble() * 4 + 2,
          life: 1.0,
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _addFirework(details.localPosition);
      },
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              // Update sparks life
              for (var spark in _sparks) {
                spark.x += spark.vx;
                spark.y += spark.vy;
                spark.vy += 0.15; // Gravity
                spark.life -= 0.03;
              }
              _sparks.removeWhere((s) => s.life <= 0);

              return CustomPaint(
                size: Size.infinite,
                painter: _FireworksPainter(sparks: _sparks),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _FireworkSpark {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double life;

  _FireworkSpark({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.life,
  });
}

class _FireworksPainter extends CustomPainter {
  final List<_FireworkSpark> sparks;

  _FireworksPainter({required this.sparks});

  @override
  void paint(Canvas canvas, Size size) {
    for (var spark in sparks) {
      final Paint glowPaint = Paint()
        ..color = spark.color.withOpacity(spark.life.clamp(0.0, 1.0) * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      final Paint corePaint = Paint()
        ..color = spark.color.withOpacity(spark.life.clamp(0.0, 1.0));

      canvas.drawCircle(Offset(spark.x, spark.y), spark.size * 2, glowPaint);
      canvas.drawCircle(Offset(spark.x, spark.y), spark.size, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter oldDelegate) => true;
}
