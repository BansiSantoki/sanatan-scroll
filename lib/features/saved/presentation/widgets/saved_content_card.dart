import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/share_service.dart';
import '../../../../models/saved_item_model.dart';

class SavedContentCard extends StatelessWidget {
  const SavedContentCard({
    super.key,
    required this.item,
    required this.onRemove,
    this.index = 0,
  });

  final SavedItemModel item;
  final VoidCallback onRemove;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cardStyle = _getCardStyle(index, item.title, item.source);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardStyle.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEAE2D2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Watermark Line Art
            Positioned(
              right: 12,
              top: 12,
              bottom: 12,
              width: 130,
              child: CustomPaint(
                painter: cardStyle.watermarkPainter,
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B1B1B),
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.content,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4A4B46),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.source,
                          style: GoogleFonts.manrope(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: cardStyle.sourceColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Right Side Actions (Bookmark Top & Share Bottom)
                  SizedBox(
                    height: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: onRemove,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            Icons.bookmark_rounded,
                            color: cardStyle.bookmarkColor,
                            size: 24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ShareService.showOptions(
                            context: context,
                            title: item.title,
                            text:
                                '${item.title}\n\n"${item.content}"\n\n${item.source}\n\nSanatan Scroll',
                          ),
                          behavior: HitTestBehavior.opaque,
                          child: const Icon(
                            Icons.share_outlined,
                            color: Color(0xFF5A5A5A),
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _CardStyleConfig _getCardStyle(int index, String title, String source) {
    final titleLower = title.toLowerCase();

    if (titleLower.contains('selfless') || index == 0) {
      return _CardStyleConfig(
        gradientColors: const [Color(0xFFFFF8F0), Color(0xFFFDECDA)],
        bookmarkColor: const Color(0xFFC85A32),
        sourceColor: const Color(0xFF8C6647),
        watermarkPainter: _LotusWatermarkPainter(),
      );
    }

    if (titleLower.contains('equanimity') || index == 1) {
      return _CardStyleConfig(
        gradientColors: const [Color(0xFFF4F6EC), Color(0xFFEAEFD8)],
        bookmarkColor: const Color(0xFFC85A32),
        sourceColor: const Color(0xFF8C6647),
        watermarkPainter: _LeavesWatermarkPainter(),
      );
    }

    if (titleLower.contains('morning') || index == 2) {
      return _CardStyleConfig(
        gradientColors: const [Color(0xFFFDF7E8), Color(0xFFF9EED4)],
        bookmarkColor: const Color(0xFF5A6C38),
        sourceColor: const Color(0xFF8C6647),
        watermarkPainter: _MandalaWatermarkPainter(),
      );
    }

    if (titleLower.contains('letting') || index == 3) {
      return _CardStyleConfig(
        gradientColors: const [Color(0xFFFFF5ED), Color(0xFFFDE6D5)],
        bookmarkColor: const Color(0xFFC85A32),
        sourceColor: const Color(0xFF8C6647),
        watermarkPainter: _FlourishWatermarkPainter(),
      );
    }

    if (titleLower.contains('eternal') || index == 4) {
      return _CardStyleConfig(
        gradientColors: const [Color(0xFFFFF8F2), Color(0xFFFDE9DA)],
        bookmarkColor: const Color(0xFFC85A32),
        sourceColor: const Color(0xFF8C6647),
        watermarkPainter: _TempleWatermarkPainter(),
      );
    }

    return _CardStyleConfig(
      gradientColors: const [Color(0xFFF4F6EC), Color(0xFFE8EED8)],
      bookmarkColor: const Color(0xFF5A6C38),
      sourceColor: const Color(0xFF8C6647),
      watermarkPainter: _LeavesWatermarkPainter(),
    );
  }
}

class _CardStyleConfig {
  final List<Color> gradientColors;
  final Color bookmarkColor;
  final Color sourceColor;
  final CustomPainter watermarkPainter;

  const _CardStyleConfig({
    required this.gradientColors,
    required this.bookmarkColor,
    required this.sourceColor,
    required this.watermarkPainter,
  });
}

// ============================================================
// WATERMARK LINE-ART PAINTERS (Low Opacity)
// ============================================================

class _LotusWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC85A32).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final cx = size.width * 0.70;
    final cy = size.height * 0.50;

    final path = Path();
    path.moveTo(cx, cy - 25);
    path.quadraticBezierTo(cx + 18, cy - 10, cx, cy + 20);
    path.quadraticBezierTo(cx - 18, cy - 10, cx, cy - 25);

    path.moveTo(cx, cy);
    path.quadraticBezierTo(cx + 28, cy - 5, cx + 22, cy + 18);
    path.moveTo(cx, cy);
    path.quadraticBezierTo(cx - 28, cy - 5, cx - 22, cy + 18);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeavesWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5A6C38).withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final cx = size.width * 0.65;
    final cy = size.height * 0.50;

    final stem = Path();
    stem.moveTo(cx - 10, cy + 30);
    stem.cubicTo(cx, cy + 10, cx + 10, cy - 10, cx + 15, cy - 30);
    canvas.drawPath(stem, paint);

    _drawLeaf(canvas, Offset(cx + 15, cy - 30), 0, paint);
    _drawLeaf(canvas, Offset(cx + 6, cy - 10), -0.6, paint);
    _drawLeaf(canvas, Offset(cx + 12, cy + 5), 0.6, paint);
  }

  void _drawLeaf(Canvas canvas, Offset center, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(10, -8, 16, -14);
    path.quadraticBezierTo(6, 4, 0, 0);
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MandalaWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD69A5E).withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cx = size.width * 0.70;
    final cy = size.height * 0.50;

    canvas.drawCircle(Offset(cx, cy), 32, paint);
    canvas.drawCircle(Offset(cx, cy), 22, paint);
    canvas.drawCircle(Offset(cx, cy), 12, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlourishWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC85A32).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final cx = size.width * 0.65;
    final cy = size.height * 0.50;

    final path = Path();
    path.moveTo(cx - 20, cy + 20);
    path.cubicTo(cx, cy - 20, cx + 20, cy + 20, cx + 35, cy - 15);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TempleWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC85A32).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final cx = size.width * 0.60;
    final cy = size.height * 0.60;

    final path = Path();
    path.moveTo(cx - 20, cy);
    path.lineTo(cx - 15, cy - 20);
    path.lineTo(cx, cy - 35);
    path.lineTo(cx + 15, cy - 20);
    path.lineTo(cx + 20, cy);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
