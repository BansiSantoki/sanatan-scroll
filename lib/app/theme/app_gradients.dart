import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF6B1F2A), Color(0xFFA64036)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmSpiritual = LinearGradient(
    colors: [Color(0xFFD97745), Color(0xFF8B2730)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldenAccent = LinearGradient(
    colors: [Color(0xFFE8B36B), Color(0xFFD97745)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splash = LinearGradient(
    colors: [Color(0xFF4A1018), Color(0xFF6B1F2A), Color(0xFFD97745)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient heroOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC2E2525)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient streakCard = LinearGradient(
    colors: [Color(0xFF4A1018), Color(0xFF7A2630), Color(0xFF9B2E35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Very subtle warm gradient for screen backgrounds.
  static const LinearGradient screenBackground = LinearGradient(
    colors: [
      Color(0xFFFFF8EA),
      Color(0xFFFBF2DE),
      Color(0xFFF4E7D2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.52, 1.0],
  );

  static LinearGradient sacredCard(int index) {
    final gradients = [
      [const Color(0xFF4A1018), const Color(0xFF8B2730)],
      [const Color(0xFF2C1810), const Color(0xFF6B1F2A)],
      [const Color(0xFF1A2E1A), const Color(0xFF4A6741)],
      [const Color(0xFF3D1F00), const Color(0xFF8B4513)],
      [const Color(0xFF1A1A3E), const Color(0xFF4A4A8B)],
      [const Color(0xFF2E1A1A), const Color(0xFF7A2630)],
      [const Color(0xFF1F2E1F), const Color(0xFF5D7A5D)],
      [const Color(0xFF3E2723), const Color(0xFF795548)],
    ];
    final colors = gradients[index % gradients.length];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
