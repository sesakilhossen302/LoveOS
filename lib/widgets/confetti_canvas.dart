import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiCanvas extends StatefulWidget {
  const ConfettiCanvas({super.key});

  @override
  State<ConfettiCanvas> createState() => _ConfettiCanvasState();
}

class _ConfettiCanvasState extends State<ConfettiCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiPiece> _pieces = [];
  final Random _random = Random();

  final List<Color> _colors = const [
    Color(0xFFFF2A6D),
    Color(0xFFFF7597),
    Color(0xFFFFD700),
    Color(0xFF00F5D4),
    Color(0xFF7B2CBF),
    Color(0xFF9D4EDD),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    for (int i = 0; i < 80; i++) {
      _pieces.add(_ConfettiPiece(
        x: _random.nextDouble(),
        y: _random.nextDouble() * -1.0, // start above
        size: _random.nextDouble() * 8 + 4,
        color: _colors[i % _colors.length],
        rotation: _random.nextDouble() * 2 * pi,
        speedY: _random.nextDouble() * 0.4 + 0.3,
        speedX: (_random.nextDouble() - 0.5) * 0.2,
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
          size: Size.infinite,
          painter: _ConfettiPainter(
            pieces: _pieces,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _ConfettiPiece {
  double x;
  double y;
  double size;
  Color color;
  double rotation;
  double speedY;
  double speedX;

  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.rotation,
    required this.speedY,
    required this.speedX,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var piece in pieces) {
      double py = ((piece.y + (progress * piece.speedY)) % 1.2) * size.height;
      double px = (piece.x + sin(progress * 4 * pi + piece.rotation) * 0.05) * size.width;

      final Paint paint = Paint()..color = piece.color;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(piece.rotation + progress * 4);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
