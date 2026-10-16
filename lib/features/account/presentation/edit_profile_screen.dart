import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../core/constants/nigerian_locations.dart';
import '../../../core/data/repositories/file_repository.dart';
import '../../../core/service/session_service.dart';
import '../logic/profile_provider.dart';
import 'widgets/profile_text_field.dart';
import 'widgets/profile_media_section.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? userData;

  const EditProfileScreen({super.key, this.userData});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;

  File? _newProfileImage;
  File? _newCoverImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileHeaderProvider).value;

    _fullNameController = TextEditingController(
      text: widget.userData?['fullName'] ?? widget.userData?['name'] ?? profile?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userData?['phone'] ?? widget.userData?['phoneNumber'] ?? profile?.phoneNumber ?? '',
    );
    _bioController = TextEditingController(
      text: widget.userData?['bio'] ?? '',
    );
    _countryController = TextEditingController(
      text: widget.userData?['country'] ?? 'Nigeria',
    );
    _stateController = TextEditingController(
      text: widget.userData?['state'] ?? '',
    );
    _cityController = TextEditingController(
      text: widget.userData?['city'] ?? '',
    );
    _addressController = TextEditingController(
      text: widget.userData?['address'] ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = ref.watch(profileHeaderProvider).value;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1E2329)
            : AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: _isLoading ? null : () => context.pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileMediaSection(
                  initialAvatarUrl: profile?.avatarUrl,
                  initialCoverUrl: profile?.bannerUrl,
                  onProfileImageChanged: (file) {
                    setState(() {
                      _newProfileImage = file;
                    });
                  },
                  onCoverImageChanged: (file) {
                    setState(() {
                      _newCoverImage = file;
                    });
                  },
                ),
                SizedBox(height: 32.h),
                _buildSectionHeader('Edit Profile Information', isDark),
                SizedBox(height: 24.h),

                ProfileTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                ),
                SizedBox(height: 20.h),
                ProfileTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20.h),
                ProfileTextField(
                  controller: _bioController,
                  label: 'Bio',
                  maxLines: 4,
                ),

                SizedBox(height: 32.h),
                _buildSectionHeader('Address Details', isDark),
                SizedBox(height: 24.h),

                ProfileTextField(
                  controller: _countryController,
                  label: 'Country',
                ),
                SizedBox(height: 20.h),
                _buildDropdownSelector(
                  label: 'State',
                  value: _stateController.text,
                  hint: 'Select State',
                  isDark: isDark,
                  onTap: () => _showStatePicker(context, isDark),
                ),
                SizedBox(height: 20.h),
                _buildDropdownSelector(
                  label: 'City',
                  value: _cityController.text,
                  hint: _stateController.text.isEmpty
                      ? 'Select State first'
                      : 'Select City',
                  isDark: isDark,
                  onTap: () => _showCityPicker(context, isDark),
                ),
                SizedBox(height: 20.h),
                ProfileTextField(
                  controller: _addressController,
                  label: 'Address',
                  maxLines: 2,
                ),

                SizedBox(height: 48.h),

                // Save Changes button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6C2F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFFFF6C2F).withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 22.h,
                            width: 22.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSelector({
    required String label,
    required String value,
    required String hint,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final hasValue = value.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value : hint,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: hasValue
                          ? (isDark ? Colors.white70 : Colors.black87)
                          : (isDark ? Colors.grey[500] : Colors.grey[400]),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showStatePicker(BuildContext context, bool isDark) {
    final allStates = NigerianLocations.getAllStates();
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredStates = allStates
              .where((s) => s.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Select State',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  onChanged: (val) {
                    setModalState(() => searchQuery = val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search state...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredStates.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: isDark ? Colors.white10 : Colors.grey[200],
                    ),
                    itemBuilder: (context, index) {
                      final stateName = filteredStates[index];
                      final isSelected = _stateController.text == stateName;

                      return ListTile(
                        title: Text(
                          stateName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFFFF6C2F)
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Color(0xFFFF6C2F))
                            : null,
                        onTap: () {
                          setState(() {
                            _stateController.text = stateName;
                            _cityController.clear();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCityPicker(BuildContext context, bool isDark) {
    final selectedState = _stateController.text.trim();
    if (selectedState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a State first'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final cities = NigerianLocations.getCitiesForState(selectedState);
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final filteredCities = cities
              .where((c) => c.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Select City ($selectedState)',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  onChanged: (val) {
                    setModalState(() => searchQuery = val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: filteredCities.isEmpty
                      ? Center(
                          child: Text(
                            'No cities found',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredCities.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: isDark ? Colors.white10 : Colors.grey[200],
                          ),
                          itemBuilder: (context, index) {
                            final cityName = filteredCities[index];
                            final isSelected = _cityController.text == cityName;

                            return ListTile(
                              title: Text(
                                cityName,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFFFF6C2F)
                                      : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Color(0xFFFF6C2F))
                                  : null,
                              onTap: () {
                                setState(() {
                                  _cityController.text = cityName;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : AppColors.grey800,
          ),
        ),
        if (title == 'Edit Profile Information') ...[
          SizedBox(height: 8.h),
          Divider(color: isDark ? Colors.white10 : Colors.grey[300]),
        ],
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await SessionService.getUser();
      final userId = user?['id']?.toString() ?? user?['userId']?.toString();

      if (userId == null || userId.isEmpty) {
        throw Exception('User session not found. Please log in again.');
      }

      String? avatarUrl;
      String? coverUrl;

      // 1. Upload profile image if picked
      if (_newProfileImage != null) {
        final fileRepo = ref.read(fileRepositoryProvider);
        avatarUrl = await fileRepo.uploadFile(_newProfileImage!.path, prefix: 'avatar');
      }

      // 2. Upload cover image if picked
      if (_newCoverImage != null) {
        final fileRepo = ref.read(fileRepositoryProvider);
        coverUrl = await fileRepo.uploadFile(_newCoverImage!.path, prefix: 'cover');
      }

      // 3. Build update payload
      final Map<String, dynamic> updateData = {
        'name': _fullNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'country': _countryController.text.trim(),
        'state': _stateController.text.trim(),
        'city': _cityController.text.trim(),
        'address': _addressController.text.trim(),
        if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatarUrl': avatarUrl,
        if (coverUrl != null && coverUrl.isNotEmpty) 'coverUrl': coverUrl,
      };

      // 4. Update user profile on backend
      final profileRepo = ref.read(profileRepositoryProvider);
      await profileRepo.updateUserProfile(userId, updateData);

      // 5. Update local session cache if avatar changed
      if (user != null) {
        final updatedUser = Map<String, dynamic>.from(user);
        updatedUser['name'] = updateData['name'];
        updatedUser['phoneNumber'] = updateData['phoneNumber'];
        updatedUser['state'] = updateData['state'];
        updatedUser['city'] = updateData['city'];
        updatedUser['country'] = updateData['country'];
        updatedUser['address'] = updateData['address'];
        if (avatarUrl != null) updatedUser['avatarUrl'] = avatarUrl;
        if (coverUrl != null) updatedUser['coverUrl'] = coverUrl;
        await SessionService.saveUser(updatedUser);
      }

      // 6. Invalidate profile provider so UI everywhere refreshes
      ref.invalidate(profileHeaderProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
