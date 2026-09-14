import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/admin_colors.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

class BreadcrumbNav extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbNav({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AdminColors.bgSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AdminColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            size: 16,
            color: AdminColors.primary,
          ),
          const SizedBox(width: 8),
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AdminColors.textSecondary,
                ),
              ),
            InkWell(
              onTap: items[i].onTap,
              borderRadius: BorderRadius.circular(4),
              child: Text(
                items[i].label,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: i == items.length - 1 ? FontWeight.w600 : FontWeight.w400,
                  color: i == items.length - 1 ? AdminColors.primary : AdminColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

