import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/utils/avatar_helper.dart';

enum MediaCardType { circular, rectangular }

class MediaSelectionCard extends StatelessWidget {
  final String? imagePath;
  final bool isAsset;
  final MediaCardType type;
  final VoidCallback onTap;
  final String? label;
  final File? imageFile;

  const MediaSelectionCard({
    super.key,
    this.imagePath,
    required this.onTap,
    this.isAsset = false,
    this.type = MediaCardType.rectangular,
    this.label,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (type == MediaCardType.circular) {
      return _buildCircularMedia(isDark);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTexts.semiBold(
              AppTexts.bodyMedium(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: _buildRectangularMedia(isDark),
        ),
      ],
    );
  }

  Widget _buildCircularMedia(bool isDark) {
    ImageProvider provider;
    if (imageFile != null) {
      provider = FileImage(imageFile!);
    } else {
      provider = AvatarHelper.getImageProvider(imagePath);
    }

    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(2.w),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.black : Colors.white,
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image(
            image: provider,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildRectangularMedia(bool isDark) {
    final hasImage = imageFile != null || (imagePath != null && imagePath!.trim().isNotEmpty);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B2028) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: _buildImage(isDark),
            ),
            // Glassmorphism Change / Upload Button in Bottom-Right
            Positioned(
              bottom: 12.h,
              right: 12.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          hasImage ? 'Change Cover' : 'Upload Cover',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
      );
    }
    if (imagePath == null || imagePath!.trim().isEmpty) {
      return _buildPlaceholder(isDark);
    }
    return isAsset
        ? Image.asset(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholder(isDark),
          )
        : Image.network(
            imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholder(isDark),
          );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1B2028) : const Color(0xFFE2E8F0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: isDark ? Colors.white24 : Colors.grey[400],
              size: 36.sp,
            ),
            SizedBox(height: 6.h),
            Text(
              'No cover photo',
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[500],
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
