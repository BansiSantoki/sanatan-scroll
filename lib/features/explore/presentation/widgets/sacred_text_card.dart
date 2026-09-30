import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/sacred_text_model.dart';

class SacredTextCard extends StatelessWidget {
  const SacredTextCard({
    super.key,
    required this.text,
    required this.onTap,
    this.showBookmark = true,
  });

  final SacredTextModel text;
  final VoidCallback onTap;
  final bool showBookmark;

  @override
  Widget build(BuildContext context) {
    Color cardBg;
    Widget illustration;
    String displayTitle = text.title;
    String displaySubtitle = text.subtitle;

    final id = text.id.toLowerCase();
    final localeCode = Localizations.localeOf(context).languageCode;

    if (id == 'bhagavad_gita' || id.contains('gita')) {
      cardBg = const Color(0xFFE47A46); // Saffron Orange (matching image)
      displayTitle = switch (localeCode) {
        'gu' => 'ભગવદ્ ગીતા',
        'hi' => 'भगवद्गीता',
        _ => 'Bhagavad Gita',
      };
      displaySubtitle = switch (localeCode) {
        'gu' => 'પરમ ભક્તિ અને ધર્મનો સંગીત',
        'hi' => 'परम भक्ति और धर्म का संगीत',
        _ => 'The Divine Song of\nLord Krishna',
      };
      illustration = Image.asset(
        'assets/images/bhagavat_gita_big.png',
        fit: BoxFit.contain,
        height: 125,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/chariot_lineart.png',
          height: 125,
          fit: BoxFit.contain,
        ),
      );
    } else if (id == 'ramayana' || id.contains('ramayan')) {
      cardBg = const Color(0xFF94AA84); // Sage Green
      displayTitle = switch (localeCode) {
        'gu' => 'રામાયણ',
        'hi' => 'रामायण',
        _ => 'Ramayana',
      };
      displaySubtitle = switch (localeCode) {
        'gu' => 'કર્તવ્યની મહાગાથા',
        'hi' => 'कर्तव्य की महागाथा',
        _ => 'The Epic of Duty',
      };
      illustration = Image.asset(
        'assets/images/ramayana_bow_art.png',
        fit: BoxFit.contain,
        height: 125,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(painter: _BowAndArrowPainter()),
        ),
      );
    } else if (id == 'upanishads' || id.contains('upanishad')) {
      cardBg = const Color(0xFFF2B75B); // Warm Gold / Yellow
      displayTitle = switch (localeCode) {
        'gu' => 'ઉપનિષદો',
        'hi' => 'उपनिषद',
        _ => 'Isha Upanishad',
      };
      displaySubtitle = switch (localeCode) {
        'gu' => 'મન અને આત્માની સમજ',
        'hi' => 'मन और आत्मा की समझ',
        _ => 'The Inner Teaching',
      };
      illustration = Image.asset(
        'assets/images/upanishad_leaf_art.png',
        fit: BoxFit.contain,
        height: 125,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => SizedBox(
          width: 110,
          height: 100,
          child: CustomPaint(painter: _PalmLeafPainter()),
        ),
      );
    } else {
      cardBg = const Color(0xFFF2E6D8);
      illustration = Text(
        text.iconEmoji,
        style: const TextStyle(fontSize: 48),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cardBg.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
        child: Column(
          children: [
            // Top Illustration
            Expanded(
              child: Center(
                child: illustration,
              ),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              displayTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF141814),
                height: 1.1,
              ),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              displaySubtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2C2824),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Bow & Arrow (Ramayana)
class _BowAndArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A2A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final width = size.width;
    final height = size.height;

    // Bow Arc (Right side curved bow)
    final bowPath = Path();
    bowPath.moveTo(width * 0.65, height * 0.12);
    bowPath.cubicTo(
      width * 0.98, height * 0.35,
      width * 0.98, height * 0.65,
      width * 0.65, height * 0.88,
    );
    canvas.drawPath(bowPath, paint);

    // Bow string
    final stringPaint = Paint()
      ..color = const Color(0xFF1A2A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(width * 0.65, height * 0.12),
      Offset(width * 0.65, height * 0.88),
      stringPaint,
    );

    // Main Arrow pointing upper-left
    canvas.drawLine(
      Offset(width * 0.80, height * 0.82),
      Offset(width * 0.22, height * 0.18),
      paint..strokeWidth = 2.2,
    );

    // Arrowhead
    final arrowHead = Path();
    arrowHead.moveTo(width * 0.22, height * 0.18);
    arrowHead.lineTo(width * 0.34, height * 0.22);
    arrowHead.moveTo(width * 0.22, height * 0.18);
    arrowHead.lineTo(width * 0.26, height * 0.30);
    canvas.drawPath(arrowHead, paint);

    // Quiver with 3 arrows behind the bow
    final quiverPaint = Paint()
      ..color = const Color(0xFF1A2A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    // Parallel Arrow shafts in quiver
    canvas.drawLine(
      Offset(width * 0.30, height * 0.88),
      Offset(width * 0.52, height * 0.25),
      quiverPaint,
    );
    canvas.drawLine(
      Offset(width * 0.22, height * 0.82),
      Offset(width * 0.44, height * 0.20),
      quiverPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Palm Leaf Manuscript / Granth (Isha Upanishad)
class _PalmLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C2010)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final width = size.width;
    final height = size.height;

    // Top Leaf (Perspective slanted block)
    final path1 = Path();
    path1.moveTo(width * 0.15, height * 0.35);
    path1.lineTo(width * 0.82, height * 0.22);
    path1.lineTo(width * 0.88, height * 0.38);
    path1.lineTo(width * 0.20, height * 0.52);
    path1.close();
    canvas.drawPath(path1, paint);

    // Bottom Leaf (Perspective slanted block)
    final path2 = Path();
    path2.moveTo(width * 0.12, height * 0.56);
    path2.lineTo(width * 0.79, height * 0.42);
    path2.lineTo(width * 0.85, height * 0.58);
    path2.lineTo(width * 0.18, height * 0.72);
    path2.close();
    canvas.drawPath(path2, paint);

    // Binding cords (vertical straps wrapping leaves)
    final cordPaint = Paint()
      ..color = const Color(0xFF2C2010)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    canvas.drawLine(
      Offset(width * 0.38, height * 0.28),
      Offset(width * 0.40, height * 0.70),
      cordPaint,
    );

    canvas.drawLine(
      Offset(width * 0.62, height * 0.23),
      Offset(width * 0.64, height * 0.64),
      cordPaint,
    );

    // Sanskrit script lines on leaf
    final linePaint = Paint()
      ..color = const Color(0xFF2C2010)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(width * 0.22, height * 0.40),
      Offset(width * 0.34, height * 0.38),
      linePaint,
    );
    canvas.drawLine(
      Offset(width * 0.44, height * 0.36),
      Offset(width * 0.58, height * 0.34),
      linePaint,
    );
    canvas.drawLine(
      Offset(width * 0.68, height * 0.32),
      Offset(width * 0.80, height * 0.30),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
