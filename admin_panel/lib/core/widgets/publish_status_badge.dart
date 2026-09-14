import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/admin_colors.dart';

class PublishStatusBadge extends StatelessWidget {
  final bool published;
  final VoidCallback? onTap;

  const PublishStatusBadge({
    super.key,
    required this.published,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = published ? AdminColors.successBg : AdminColors.warningBg;
    final textColor = published ? AdminColors.success : AdminColors.warning;
    final label = published ? 'Published' : 'Draft';
    final icon = published ? Icons.check_circle : Icons.edit_note;

    final badgeWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withAlpha(80), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: badgeWidget,
      );
    }
    return badgeWidget;
  }
}
