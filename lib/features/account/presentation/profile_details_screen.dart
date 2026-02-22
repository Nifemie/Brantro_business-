import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/service/session_service.dart';
import '../../../core/utils/avatar_helper.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ConsumerState<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await SessionService.getUser();
    final fullName = await SessionService.getUserFullname();
    final email = await SessionService.getUsername();
    
    if (mounted) {
      setState(() {
        _userData = {
          'fullName': fullName ?? user?['name'] ?? 'N/A',
          'email': email ?? user?['emailAddress'] ?? 'N/A',
          'phone': user?['phoneNumber'] ?? 'N/A',
          'address': user?['address'] ?? 'N/A',
          'city': user?['city'] ?? '',
          'state': user?['state'] ?? '',
          'country': user?['country'] ?? '',
          'avatarUrl': user?['avatarUrl'] ?? '',
          'userId': user?['id']?.toString() ?? user?['userId']?.toString() ?? 'user',
        };
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Profile Details',
          style: AppTexts.h3(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              context.push('/edit-profile', extra: _userData);
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24.h),

                  // Profile Avatar
                  Center(
                    child: _buildAvatar(),
                  ),

                  SizedBox(height: 32.h),

                  // Personal Information Section
                  _buildSectionHeader('Personal Information'),
                  _buildInfoCard([
                    _buildInfoTile(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: _userData?['fullName'] ?? 'N/A',
                    ),
                    Divider(height: 1, color: AppColors.grey200),
                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: _userData?['email'] ?? 'N/A',
                    ),
                    Divider(height: 1, color: AppColors.grey200),
                    _buildInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: _userData?['phone'] ?? 'N/A',
                    ),
                  ]),

                  SizedBox(height: 16.h),

                  // Address Section
                  _buildSectionHeader('Address'),
                  _buildInfoCard([
                    _buildInfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: _buildFullAddress(),
                      maxLines: 3,
                    ),
                  ]),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
    );
  }

  String _buildFullAddress() {
    final parts = <String>[];
    
    if (_userData?['address'] != null && _userData!['address'] != 'N/A') {
      parts.add(_userData!['address']);
    }
    if (_userData?['city'] != null && _userData!['city'].toString().isNotEmpty) {
      parts.add(_userData!['city']);
    }
    if (_userData?['state'] != null && _userData!['state'].toString().isNotEmpty) {
      parts.add(_userData!['state']);
    }
    if (_userData?['country'] != null && _userData!['country'].toString().isNotEmpty) {
      parts.add(_userData!['country']);
    }

    return parts.isEmpty ? 'N/A' : parts.join(', ');
  }

  Widget _buildAvatar() {
    final avatarUrl = AvatarHelper.getAvatar(
      avatarUrl: _userData?['avatarUrl'],
      userId: _userData?['userId'] ?? 'user',
    );

    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryColor,
          width: 3,
        ),
        image: DecorationImage(
          image: AvatarHelper.isDefaultAvatar(avatarUrl)
              ? AssetImage(avatarUrl) as ImageProvider
              : NetworkImage(avatarUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTexts.h4(color: AppColors.grey600),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
