import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom background widget that faithfully recreates the visual design from
/// the reference image for the Sanatan Scroll Splash Screen.
///
/// Elements rendered:
/// 1. Rich warm orange gradient background with fine grain/texture feel.
/// 2. Soft golden yellow sun circle in the upper right.
/// 3. Traditional 8-spoke star/asterisk symbol in terracotta orange near the right edge.
/// 4. Layered warm orange abstract organic wave in the lower right.
/// 5. Dark forest green curved dome shape in the bottom-right corner.
/// 6. Layered botanical leaves (olive green with orange shadow leaves) in the bottom-left corner.
class OrangeSplashBackground extends StatelessWidget {
  final Widget? child;

  const OrangeSplashBackground({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Base warm orange fill matching the image tone
          const ColoredBox(
            color: Color(0xFFEA752A),
          ),

          // Full-bleed background image with high filter quality
          Positioned.fill(
            child: Image.asset(
              'assets/images/a_clean_abstract_graphic_background_scene_a_warm.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return CustomPaint(
                  painter: _OrangeSplashPainter(),
                );
              },
            ),
          ),

          if (child != null) child!,
        ],
      ),
    );
  }
}

class _OrangeSplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // =========================================================================
    // 1. BASE BACKGROUND GRADIENT & FINE TEXTURE
    // =========================================================================
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFEA752A), // Top warm orange
          Color(0xFFE56920), // Mid warm orange
          Color(0xFFDB5A16), // Bottom rich orange
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Subtle paper/grain noise simulation (soft radial highlight near upper center)
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3),
        radius: 0.9,
        colors: [
          const Color(0xFFF38A41).withValues(alpha: 0.35),
          Colors.transparent,
        ],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, highlightPaint);

    // =========================================================================
    // 2. LAYERED ORANGE ABSTRACT WAVE (Lower-Right Background Curve)
    // =========================================================================
    final wavePath = Path();
    wavePath.moveTo(w * 0.32, h);
    wavePath.cubicTo(
      w * 0.40,
      h * 0.76,
      w * 0.65,
      h * 0.67,
      w,
      h * 0.68,
    );
    wavePath.lineTo(w, h);
    wavePath.close();

    final wavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFF0853B).withValues(alpha: 0.85),
          const Color(0xFFE36D21).withValues(alpha: 0.95),
        ],
      ).createShader(Rect.fromLTWH(w * 0.32, h * 0.65, w * 0.68, h * 0.35));
    canvas.drawPath(wavePath, wavePaint);

    // Second subtle soft curve overlay
    final wavePath2 = Path();
    wavePath2.moveTo(w * 0.45, h);
    wavePath2.cubicTo(
      w * 0.55,
      h * 0.82,
      w * 0.72,
      h * 0.73,
      w,
      h * 0.74,
    );
    wavePath2.lineTo(w, h);
    wavePath2.close();

    final wavePaint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFED7D31).withValues(alpha: 0.4),
          const Color(0xFFDE6019).withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromLTWH(w * 0.45, h * 0.73, w * 0.55, h * 0.27));
    canvas.drawPath(wavePath2, wavePaint2);

    // =========================================================================
    // 3. TOP-RIGHT GOLDEN SUN CIRCLE
    // =========================================================================
    final sunRadius = (w * 0.19).clamp(70.0, 130.0);
    final sunCenter = Offset(w * 0.78, h * 0.13);

    final sunPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        radius: 0.85,
        colors: [
          const Color(0xFFFED867), // Bright golden center
          const Color(0xFFF7B133), // Rich yellow orange edge
        ],
      ).createShader(
        Rect.fromCircle(center: sunCenter, radius: sunRadius),
      );
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // =========================================================================
    // 4. TRADITIONAL 8-SPOKE ASTERISK / STAR SYMBOL
    // =========================================================================
    final starCenter = Offset(w * 0.88, h * 0.325);
    final starRadius = (w * 0.045).clamp(16.0, 24.0);
    final starPaint = Paint()
      ..color = const Color(0xFFC74C16)
      ..strokeWidth = (starRadius * 0.22).clamp(3.0, 5.0)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final angle = i * (math.pi / 4);
      final dx = math.cos(angle) * starRadius;
      final dy = math.sin(angle) * starRadius;
      canvas.drawLine(
        Offset(starCenter.dx - dx, starCenter.dy - dy),
        Offset(starCenter.dx + dx, starCenter.dy + dy),
        starPaint,
      );
    }

    // =========================================================================
    // 5. BOTTOM-RIGHT DARK GREEN CURVED DOME SHAPE
    // =========================================================================
    final greenDomeRadius = (w * 0.34).clamp(120.0, 220.0);
    final greenDomeCenter = Offset(w * 0.98, h * 1.02);

    final greenDomePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.9,
        colors: [
          const Color(0xFF264A35), // Forest green highlight
          const Color(0xFF1B3827), // Deep dark olive green
        ],
      ).createShader(
        Rect.fromCircle(center: greenDomeCenter, radius: greenDomeRadius),
      );
    canvas.drawCircle(greenDomeCenter, greenDomeRadius, greenDomePaint);

    // =========================================================================
    // 6. BOTTOM-LEFT BOTANICAL LEAF ILLUSTRATION
    // =========================================================================
    // Base origin point in bottom-left off-screen
    final leafOrigin = Offset(-w * 0.04, h * 1.02);

    // Layer 6A: Subtle Translucent Orange Shadow Leaves Behind
    _drawLeafBranch(
      canvas: canvas,
      origin: leafOrigin,
      scale: w * 0.0034,
      rotationAngle: -0.22,
      leafColor: const Color(0xFFD65818).withValues(alpha: 0.45),
      stemColor: const Color(0xFFC44B12).withValues(alpha: 0.4),
      isShadowLayer: true,
    );

    // Layer 6B: Primary Dark Olive Green Leaves
    _drawLeafBranch(
      canvas: canvas,
      origin: leafOrigin,
      scale: w * 0.0032,
      rotationAngle: -0.05,
      leafColor: const Color(0xFF24432C),
      stemColor: const Color(0xFF1B3321),
      isShadowLayer: false,
    );
  }

  /// Draws a natural botanical leaf branch with main stem and radiating almond-shaped leaves.
  void _drawLeafBranch({
    required Canvas canvas,
    required Offset origin,
    required double scale,
    required double rotationAngle,
    required Color leafColor,
    required Color stemColor,
    required bool isShadowLayer,
  }) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(rotationAngle);

    final stemPaint = Paint()
      ..color = stemColor
      ..strokeWidth = scale * 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;

    // Stem path curving upwards and to the right
    final stemPath = Path();
    stemPath.moveTo(0, 0);
    stemPath.cubicTo(
      60 * scale,
      -70 * scale,
      130 * scale,
      -130 * scale,
      210 * scale,
      -200 * scale,
    );
    canvas.drawPath(stemPath, stemPaint);

    // Leaf definitions relative to stem points [stemX, stemY, leafLength, angleDegrees, widthScale]
    final leaves = [
      // Bottom leaves
      [40.0 * scale, -45.0 * scale, 95.0 * scale, -70.0, 0.38],
      [65.0 * scale, -75.0 * scale, 110.0 * scale, 18.0, 0.40],
      // Middle leaves
      [100.0 * scale, -110.0 * scale, 125.0 * scale, -55.0, 0.42],
      [125.0 * scale, -135.0 * scale, 120.0 * scale, 12.0, 0.38],
      // Upper-mid leaves
      [160.0 * scale, -165.0 * scale, 115.0 * scale, -40.0, 0.36],
      [180.0 * scale, -180.0 * scale, 95.0 * scale, 0.0, 0.34],
      // Tip leaf
      [205.0 * scale, -195.0 * scale, 90.0 * scale, -22.0, 0.30],
    ];

    for (final l in leaves) {
      final lx = l[0];
      final ly = l[1];
      final leafLength = l[2];
      final angleRad = l[3] * (math.pi / 180);
      final widthRatio = l[4];

      _drawSingleLeaf(
        canvas: canvas,
        attachPoint: Offset(lx, ly),
        length: leafLength,
        angleRad: angleRad,
        widthRatio: widthRatio,
        leafPaint: leafPaint,
        drawVein: !isShadowLayer,
      );
    }

    canvas.restore();
  }

  /// Draws an elegant almond-shaped leaf blade with an optional central vein line.
  void _drawSingleLeaf({
    required Canvas canvas,
    required Offset attachPoint,
    required double length,
    required double angleRad,
    required double widthRatio,
    required Paint leafPaint,
    required bool drawVein,
  }) {
    canvas.save();
    canvas.translate(attachPoint.dx, attachPoint.dy);
    canvas.rotate(angleRad);

    final leafWidth = length * widthRatio;

    final leafPath = Path();
    leafPath.moveTo(0, 0);

    // Left curve to tip
    leafPath.cubicTo(
      -leafWidth * 0.8,
      -length * 0.35,
      -leafWidth * 0.5,
      -length * 0.85,
      0,
      -length,
    );

    // Right curve back to base
    leafPath.cubicTo(
      leafWidth * 0.5,
      -length * 0.85,
      leafWidth * 0.8,
      -length * 0.35,
      0,
      0,
    );

    leafPath.close();
    canvas.drawPath(leafPath, leafPaint);

    if (drawVein) {
      final veinPaint = Paint()
        ..color = const Color(0xFF19301F).withValues(alpha: 0.5)
        ..strokeWidth = (length * 0.015).clamp(1.0, 2.5)
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        const Offset(0, 0),
        Offset(0, -length * 0.85),
        veinPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
