import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../providers/saved_provider.dart';
import 'widgets/saved_content_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width >= 900
        ? 40.0
        : width >= 600
            ? 28.0
            : 20.0;

    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      body: SafeArea(
        child: Stack(
          children: [
            // Top Right Background Decorative Spiritual Artwork (Sun, Temple & Leaves)
            Positioned(
              top: -10,
              right: -10,
              child: CustomPaint(
                size: const Size(200, 200),
                painter: _HeaderSpiritualArtPainter(),
              ),
            ),

            // Main Content Area
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Header (Saved Title & Subtitle)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.saved,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B1B1B),
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Your personal collection of wisdom',
                            style: GoogleFonts.manrope(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Horizontal Category Tabs
                    Consumer<SavedProvider>(
                      builder: (context, saved, _) {
                        return SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            itemCount: AppConstants.savedFilters.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 24),
                            itemBuilder: (context, index) {
                              final filter = AppConstants.savedFilters[index];
                              final isSelected = saved.activeFilter == filter;

                              return GestureDetector(
                                onTap: () => saved.setFilter(filter),
                                behavior: HitTestBehavior.opaque,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      filter,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? const Color(0xFFC85A32)
                                            : const Color(0xFF4A4B46),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: isSelected ? 32 : 0,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC85A32),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Saved Cards List
                    Expanded(
                      child: Consumer<SavedProvider>(
                        builder: (context, saved, _) {
                          final items = saved.items;

                          if (items.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC85A32).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.bookmark_outline_rounded,
                                        size: 32,
                                        color: Color(0xFFC85A32),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No saved wisdom yet',
                                      style: GoogleFonts.cormorantGaramond(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1B1B1B),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Save verses, reflections, and wisdom that inspire you.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: const Color(0xFF666666),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: horizontalPadding,
                              right: horizontalPadding,
                              top: 4,
                              bottom: 24,
                            ),
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return SavedContentCard(
                                item: item,
                                index: index,
                                onRemove: () => saved.removeItem(item.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HEADER SPIRITUAL BACKGROUND ART PAINTER (Sun, Temple & Leaves)
// ============================================================

class _HeaderSpiritualArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sun Rays / Sun Circle
    final sunCenter = Offset(w * 0.85, h * 0.25);
    final sunPaint = Paint()
      ..color = const Color(0xFFD69A5E).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(sunCenter, 28, sunPaint);

    // Temple Silhouette Spires (Line art)
    final templePaint = Paint()
      ..color = const Color(0xFFD69A5E).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final temple = Path();
    temple.moveTo(w * 0.55, h * 0.55);
    temple.lineTo(w * 0.65, h * 0.35);
    temple.lineTo(w * 0.70, h * 0.55);
    temple.lineTo(w * 0.80, h * 0.25);
    temple.lineTo(w * 0.90, h * 0.55);
    canvas.drawPath(temple, templePaint);

    // Botanical Leaves Branch
    final leavesPaint = Paint()
      ..color = const Color(0xFF5A6C38).withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final stem = Path();
    stem.moveTo(w * 0.95, h * 0.50);
    stem.quadraticBezierTo(w * 0.75, h * 0.65, w * 0.60, h * 0.85);
    canvas.drawPath(stem, leavesPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
