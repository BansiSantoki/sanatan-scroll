// Automatic FlutterFlow Custom Widget
// Name: WatermarkBackgroundWidget
// Description: Spiritual background watermark painter for Lotus, Leaves, Mandala, Flourish, and Temple motifs.

import 'dart:math' as math;
import 'package:flutter/material.dart';

enum WatermarkType { lotus, leaves, mandala, flourish, temple }

class WatermarkBackgroundWidget extends StatelessWidget {
  const WatermarkBackgroundWidget({
    super.key,
    required this.width,
    required this.height,
    required this.type,
    this.opacity = 0.06,
    this.color = const Color(0xFF6B1F2A),
  });

  final double width;
  final double height;
  final WatermarkType type;
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _getPainter(type, color.withValues(alpha: opacity)),
      ),
    );
  }

  CustomPainter _getPainter(WatermarkType type, Color painterColor) {
    return switch (type) {
      WatermarkType.lotus => _LotusWatermarkPainter(color: painterColor),
      WatermarkType.leaves => _LeavesWatermarkPainter(color: painterColor),
      WatermarkType.mandala => _MandalaWatermarkPainter(color: painterColor),
      WatermarkType.flourish => _FlourishWatermarkPainter(color: painterColor),
      WatermarkType.temple => _TempleWatermarkPainter(color: painterColor),
    };
  }
}

class _LotusWatermarkPainter extends CustomPainter {
  final Color color;
  _LotusWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width * 0.82, size.height * 0.75);
    const petalCount = 8;
    const radius = 45.0;

    for (int i = 0; i < petalCount; i++) {
      final angle = (i * 2 * math.pi) / petalCount;
      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.quadraticBezierTo(
        center.dx + radius * math.cos(angle - 0.3),
        center.dy + radius * math.sin(angle - 0.3),
        center.dx + radius * 1.3 * math.cos(angle),
        center.dy + radius * 1.3 * math.sin(angle),
      );
      path.quadraticBezierTo(
        center.dx + radius * math.cos(angle + 0.3),
        center.dy + radius * math.sin(angle + 0.3),
        center.dx,
        center.dy,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeavesWatermarkPainter extends CustomPainter {
  final Color color;
  _LeavesWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    path.moveTo(size.width * 0.75, size.height);
    path.quadraticBezierTo(
      size.width * 0.85, size.height * 0.6,
      size.width * 0.95, size.height * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MandalaWatermarkPainter extends CustomPainter {
  final Color color;
  _MandalaWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width * 0.85, size.height * 0.8);
    canvas.drawCircle(center, 30, paint);
    canvas.drawCircle(center, 50, paint);
    canvas.drawCircle(center, 70, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlourishWatermarkPainter extends CustomPainter {
  final Color color;
  _FlourishWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    path.moveTo(size.width * 0.7, size.height * 0.9);
    path.cubicTo(
      size.width * 0.8, size.height * 0.95,
      size.width * 0.95, size.height * 0.75,
      size.width * 0.88, size.height * 0.5,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TempleWatermarkPainter extends CustomPainter {
  final Color color;
  _TempleWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path();
    final baseX = size.width * 0.78;
    final baseY = size.height * 0.95;

    path.moveTo(baseX, baseY);
    path.lineTo(baseX + 60, baseY);
    path.lineTo(baseX + 50, baseY - 30);
    path.lineTo(baseX + 40, baseY - 55);
    path.lineTo(baseX + 30, baseY - 80); // Shikhara peak
    path.lineTo(baseX + 20, baseY - 55);
    path.lineTo(baseX + 10, baseY - 30);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
