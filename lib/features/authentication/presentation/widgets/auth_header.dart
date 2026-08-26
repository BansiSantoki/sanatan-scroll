import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.84);

    final controlPoint1 = Offset(size.width * 0.38, size.height * 1.05);
    final endPoint1 = Offset(size.width * 0.72, size.height * 0.94);
    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      endPoint1.dx,
      endPoint1.dy,
    );

    final controlPoint2 = Offset(size.width * 0.88, size.height * 0.88);
    final endPoint2 = Offset(size.width, size.height * 0.98);
    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint2.dx,
      endPoint2.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height * 0.37;

    return ClipPath(
      clipper: HeaderWaveClipper(),
      child: Container(
        width: double.infinity,
        height: headerHeight,
        color: const Color(0xFFE88242),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dark Olive Trishul S Logo
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1F3323),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/sanatan_logo.png',
                  height: size.height < 650 ? 70 : 88,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),

              const SizedBox(height: 12),

              // Title "Sanatan Scroll"
              Text(
                'Sanatan Scroll',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: size.width < 360 ? 30 : 36,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F3323),
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 4),

              // Subtitle "Wisdom for your journey"
              Text(
                'Wisdom for your journey',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: size.width < 360 ? 14 : 15.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1F3323),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
