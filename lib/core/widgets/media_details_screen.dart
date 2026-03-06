import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/re_useable/app_color.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';

class MediaDetailsScreen extends ConsumerWidget {
  final String id;
  final String type; // 'billboard', 'wall', 'screen'
  final String name;
  final String location;
  final String description;
  final List<String> features;
  final String category;
  final int totalSlots;
  final int bookedSlots;
  final String createdDate;
  final bool isActive;
  final List<String> images;
  final String ownerName;
  final String ownerBadge;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerAddress;
  final String ownerLocation;

  const MediaDetailsScreen({
    super.key,
    required this.id,
    required this.type,
    required this.name,
    required this.location,
    required this.description,
    required this.features,
    required this.category,
    required this.totalSlots,
    required this.bookedSlots,
    required this.createdDate,
    required this.isActive,
    required this.images,
    required this.ownerName,
    required this.ownerBadge,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.ownerAddress,
    required this.ownerLocation,
  });

  String get _typeLabel {
    switch (type.toLowerCase()) {
      case 'billboard':
        return 'Billboard';
      case 'wall':
        return 'Wall';
      case 'screen':
        return 'Screen';
      default:
        return 'Media';
    }
  }

  String get _screenTitle {
    switch (type.toLowerCase()) {
      case 'billboard':
        return 'BILLBOARD DETAILS';
      case 'wall':
        return 'WALL DETAILS';
      case 'screen':
        return 'SCREEN DETAILS';
      default:
        return 'DETAILS';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardAppBar(title: _screenTitle),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner Image
                    _buildBannerImage(isDark),
                    
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          // Details Card
                          _buildDetailsCard(context, isDark),
                          
                          SizedBox(height: 16.h),
                          
                          // Owner/Contact Card
                          _buildOwnerCard(context, isDark),
                        ],
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

  Widget _buildBannerImage(bool isDark) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[200],
      ),
      child: images.isNotEmpty
          ? Image.asset(
              images.first,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage(isDark);
              },
            )
          : _buildPlaceholderImage(isDark),
    );
  }

  Widget _buildPlaceholderImage(bool isDark) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.3),
            AppColors.secondaryColor.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64.sp,
          color: isDark ? Colors.white38 : Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.campaign_outlined,
                  size: 24.sp,
                  color: AppColors.secondaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF00C853) : Colors.grey,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Name
          Text(
            name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A2B4B),
            ),
          ),

          SizedBox(height: 8.h),

          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Description Section
          _buildSectionHeader('Description', isDark),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),

          SizedBox(height: 16.h),

          // Features Section
          _buildSectionHeader('Features', isDark),
          SizedBox(height: 8.h),
          Text(
            features.join(', '),
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),

          SizedBox(height: 16.h),

          // Type and Category Row
          Row(
            children: [
              Expanded(
                child: _buildInfoRow('Type:', _typeLabel, isDark),
              ),
              Expanded(
                child: _buildInfoRow('Category:', category, isDark),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Slots Row
          Row(
            children: [
              Expanded(
                child: _buildInfoRow('Total Slots:', totalSlots.toString(), isDark),
              ),
              Expanded(
                child: _buildInfoRow('Booked Slots:', bookedSlots.toString(), isDark),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Created Date
          _buildInfoRow('Created:', createdDate, isDark),
        ],
      ),
    );
  }

  Widget _buildOwnerCard(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner Name and Badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 24.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ownerName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                      ),
                    ),
                    if (ownerBadge.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003D82),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          ownerBadge,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Email Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      ownerEmail,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      ownerPhone,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchEmail(ownerEmail),
                  icon: Icon(Icons.email_outlined, size: 18.sp),
                  label: Text(
                    'Email',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _launchPhone(ownerPhone),
                  icon: Icon(Icons.phone_outlined, size: 18.sp),
                  label: Text(
                    'Call',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                    side: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Address
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                ownerAddress,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Location
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                ownerLocation,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16.sp,
          color: AppColors.secondaryColor,
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A2B4B),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A2B4B),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
