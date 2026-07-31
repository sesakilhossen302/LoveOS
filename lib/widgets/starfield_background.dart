import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class StarfieldBackground extends StatefulWidget {
  final Widget child;
  final bool showHearts;

  const StarfieldBackground({
    super.key,
    required this.child,
    this.showHearts = true,
  });

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final List<FloatingHeart> _hearts = [];
  final List<RosePetal> _petals = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate random stars
    for (int i = 0; i < 70; i++) {
      _stars.add(Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.5 + 0.8,
        alpha: _random.nextDouble(),
        speed: _random.nextDouble() * 0.02 + 0.005,
      ));
    }

    // Generate random floating hearts
    for (int i = 0; i < 15; i++) {
      _hearts.add(FloatingHeart(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 16 + 10,
        speed: _random.nextDouble() * 0.001 + 0.0005,
        opacity: _random.nextDouble() * 0.4 + 0.2,
      ));
    }

    // Generate random swaying rose petals
    for (int i = 0; i < 12; i++) {
      _petals.add(RosePetal(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 14 + 14,
        speed: _random.nextDouble() * 0.0015 + 0.001,
        rotation: _random.nextDouble() * 2 * pi,
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LoveTheme.romanticGradient,
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPainterWidget(
                stars: _stars,
                hearts: widget.showHearts ? _hearts : [],
                petals: _petals,
                progress: _controller.value,
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class Star {
  double x;
  double y;
  double size;
  double alpha;
  double speed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.alpha,
    required this.speed,
  });
}

class FloatingHeart {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  FloatingHeart({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class RosePetal {
  double x;
  double y;
  double size;
  double speed;
  double rotation;

  RosePetal({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.rotation,
  });
}

class CustomPainterWidget extends StatelessWidget {
  final List<Star> stars;
  final List<FloatingHeart> hearts;
  final List<RosePetal> petals;
  final double progress;

  const CustomPainterWidget({
    super.key,
    required this.stars,
    required this.hearts,
    required this.petals,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: BackgroundPainter(
        stars: stars,
        hearts: hearts,
        petals: petals,
        progress: progress,
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final List<Star> stars;
  final List<FloatingHeart> hearts;
  final List<RosePetal> petals;
  final double progress;

  BackgroundPainter({
    required this.stars,
    required this.hearts,
    required this.petals,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint starPaint = Paint()..color = Colors.white;

    // Draw twinkling stars
    for (var star in stars) {
      final double currentAlpha =
          (sin((progress * 2 * pi) + star.alpha * 10) + 1) / 2 * 0.8 + 0.2;
      starPaint.color = Colors.white.withOpacity(currentAlpha);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        starPaint,
      );
    }

    // Draw floating hearts
    for (var heart in hearts) {
      final double yPos =
          ((heart.y - (progress * heart.speed * 100)) % 1.0) * size.height;
      final double xPos =
          heart.x * size.width + sin((progress * 4 * pi) + heart.y * 5) * 10;

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '❤️',
          style: TextStyle(
            fontSize: heart.size,
            color: Colors.pinkAccent.withOpacity(heart.opacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(xPos, yPos));
    }

    // Draw 3D swaying rose petals drifting down
    for (var petal in petals) {
      final double yPos =
          ((petal.y + (progress * petal.speed * 120)) % 1.1) * size.height;
      final double xPos =
          petal.x * size.width + sin((progress * 3 * pi) + petal.y * 8) * 20;

      final TextPainter petalPainter = TextPainter(
        text: TextSpan(
          text: '🌸',
          style: TextStyle(
            fontSize: petal.size,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      petalPainter.layout();

      canvas.save();
      canvas.translate(xPos, yPos);
      canvas.rotate(petal.rotation + sin(progress * 2 * pi + petal.x) * 0.5);
      petalPainter.paint(canvas, Offset(-petal.size / 2, -petal.size / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) => true;
}
