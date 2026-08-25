import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../providers/auth_provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final userName = auth.userName;
    final userEmail = auth.userEmail;
    final userPhotoUrl = auth.userPhotoUrl;

    return Row(
      children: [
        // ==============================
        // DYNAMIC PROFILE PHOTO
        // ==============================
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.peachHighlight,
            border: Border.all(
              color: AppColors.divider,
              width: 2,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: userPhotoUrl != null && userPhotoUrl.isNotEmpty
              ? Image.network(
                  userPhotoUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        '🧘',
                        style: TextStyle(fontSize: 32),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    '🧘',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
        ),

        const SizedBox(
          width: AppDimensions.spacing16,
        ),

        // ==============================
        // DYNAMIC NAME + EMAIL
        // ==============================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionHeading.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail.isNotEmpty ? userEmail : 'Welcome to Sanatan Scroll',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softBeige,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'My Journey',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBurgundy,
                  ),
                ),
              ),
            ],
          ),
        ),

        IconButton(
          icon: const Icon(
            Icons.edit_outlined,
            size: 20,
          ),
          color: AppColors.secondaryText,
          onPressed: onEdit,
        ),
      ],
    );
  }
}
