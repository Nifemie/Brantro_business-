import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/re_useable/app_color.dart';
import 'media_selection_card.dart';

class ProfileMediaSection extends ConsumerStatefulWidget {
  const ProfileMediaSection({super.key});

  @override
  ConsumerState<ProfileMediaSection> createState() =>
      _ProfileMediaSectionState();
}

class _ProfileMediaSectionState extends ConsumerState<ProfileMediaSection> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  File? _coverImage;

  Future<void> _pickImage(ImageSource source, bool isProfile) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (isProfile) {
            _profileImage = File(pickedFile.path);
          } else {
            _coverImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to pick image')));
      }
    }
  }

  void _showPicker(BuildContext context, String type, bool isProfile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'Update $type',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.h),
            _buildOption(
              context,
              Icons.camera_alt_outlined,
              'Take a Photo',
              () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isProfile);
              },
            ),
            SizedBox(height: 12.h),
            _buildOption(
              context,
              Icons.photo_library_outlined,
              'Choose from Gallery',
              () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, isProfile);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF6C2F), size: 24.sp),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14.sp),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Media',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.grey800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Upload a profile picture and cover photo to personalize your account.',
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.h),
            Divider(color: isDark ? Colors.white10 : Colors.grey[300]),
          ],
        ),

        SizedBox(height: 24.h),

        // Stacked Media Layout
        Center(
          child: SizedBox(
            width: double.infinity,
            height: 250.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Cover Image (16:9)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: MediaSelectionCard(
                    imagePath: 'assets/promotions/intro1.jpg',
                    imageFile: _coverImage,
                    type: MediaCardType.rectangular,
                    onTap: () => _showPicker(context, 'Cover Thumbnail', false),
                  ),
                ),

                // Profile Image (Centered and Overlapping)
                Positioned(
                  bottom: 0,
                  child: Stack(
                    children: [
                      MediaSelectionCard(
                        imagePath: 'assets/promotions/logo_design.png',
                        imageFile: _profileImage,
                        type: MediaCardType.circular,
                        onTap: () =>
                            _showPicker(context, 'Profile Photo', true),
                      ),
                      // Blue Camera Icon Overlay
                      Positioned(
                        bottom: 8.w,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () =>
                              _showPicker(context, 'Profile Photo', true),
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF007AFF),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF007AFF,
                                  ).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
