import 'package:flutter/material.dart';

import 'social_auth_button.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFF9CCA5),
    this.foregroundColor = const Color(0xFF141814),
    this.borderColor = const Color(0xFFF9CCA5),
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SocialAuthButton(
      label: 'Continue with Google',
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      leading: const _GoogleIcon(),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset( 
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2;

    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final red = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;

    final yellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;

    final green = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    canvas.drawArc(
      rect,
      -0.5,
      2.5,
      true,
      blue,
    );

    canvas.drawArc(
      rect,
      2.0,
      1.5,
      true,
      green,
    );

    canvas.drawArc(
      rect,
      3.5,
      1.5,
      true,
      yellow,
    );

    canvas.drawArc(
      rect,
      5.0,
      1.5,
      true,
      red,
    );

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius * 0.55,
      white,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - radius * 0.15,
        radius,
        radius * 0.3,
      ),
      blue,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}