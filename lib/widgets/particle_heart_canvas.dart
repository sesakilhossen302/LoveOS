import 'dart:math';
import 'package:flutter/material.dart';

class ParticleHeartCanvas extends StatefulWidget {
  const ParticleHeartCanvas({super.key});

  @override
  State<ParticleHeartCanvas> createState() => _ParticleHeartCanvasState();
}

class _ParticleHeartCanvasState extends State<ParticleHeartCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_HeartParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Create 180 particles forming a heart shape
    for (int i = 0; i < 180; i++) {
      double t = (i / 180) * 2 * pi;
      // Parametric heart formula
      double x = (16 * pow(sin(t), 3)).toDouble();
      double y = -(13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t));

      _particles.add(_HeartParticle(
        targetX: x,
        targetY: y,
        size: _random.nextDouble() * 3 + 2,
        color: i % 2 == 0
            ? const Color(0xFFFF2A6D)
            : const Color(0xFFFF7597),
        offsetT: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(280, 280),
          painter: _HeartParticlePainter(
            particles: _particles,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class _HeartParticle {
  final double targetX;
  final double targetY;
  final double size;
  final Color color;
  final double offsetT;

  _HeartParticle({
    required this.targetX,
    required this.targetY,
    required this.size,
    required this.color,
    required this.offsetT,
  });
}

class _HeartParticlePainter extends CustomPainter {
  final List<_HeartParticle> particles;
  final double animationValue;

  _HeartParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double scale = size.width / 40;

    for (var particle in particles) {
      // Pulse animation effect
      double pulse = 1.0 + sin((animationValue * 2 * pi) + particle.offsetT) * 0.08;
      
      double px = center.dx + (particle.targetX * scale * pulse);
      double py = center.dy + (particle.targetY * scale * pulse);

      final Paint glowPaint = Paint()
        ..color = particle.color.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      final Paint corePaint = Paint()..color = particle.color;

      canvas.drawCircle(Offset(px, py), particle.size * 1.8, glowPaint);
      canvas.drawCircle(Offset(px, py), particle.size, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeartParticlePainter oldDelegate) => true;
}
