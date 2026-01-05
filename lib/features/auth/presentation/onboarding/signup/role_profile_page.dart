import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../data/models/signup_request.dart';

class RoleProfilePage extends ConsumerWidget {
  final String role;
  final Map<String, dynamic> profileData;

  const RoleProfilePage({
    required this.role,
    required this.profileData,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '$role Profile',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: PlatformResponsive.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(),
              SizedBox(height: 32.h),

              // Dynamic Profile Sections
              ..._buildProfileSections(),

              SizedBox(height: 32.h),

              // Action Buttons
              _buildActionButtons(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    String title = '';
    String subtitle = '';

    switch (role) {
      case 'Artist':
        title = profileData['stageName'] ?? 'Artist Profile';
        subtitle = profileData['profession'] ?? '';
        break;
      case 'Influencer':
        title = profileData['displayName'] ?? 'Influencer Profile';
        subtitle = profileData['niche'] ?? '';
        break;
      case 'Radio Station':
        title = profileData['stationName'] ?? 'Radio Station';
        subtitle = profileData['frequency'] ?? '';
        break;
      case 'TV Station':
        title = profileData['stationName'] ?? 'TV Station';
        subtitle = profileData['channelNumber'] ?? '';
        break;
      case 'Media House':
        title = profileData['mediaName'] ?? 'Media House';
        subtitle = profileData['mediaType'] ?? '';
        break;
      case 'Advertiser':
        title = profileData['businessName'] ?? 'Advertiser';
        subtitle = profileData['industry'] ?? '';
        break;
      case 'Screen / Billboard':
        title = profileData['businessName'] ?? 'Host';
        subtitle = profileData['industry'] ?? '';
        break;
      case 'Content Producer':
        title = profileData['businessName'] ?? 'Producer';
        subtitle = profileData['contentType'] ?? '';
        break;
      case 'Host':
        title = profileData['businessName'] ?? 'Host';
        subtitle = profileData['industry'] ?? '';
        break;
    }

    return Container(
      padding: PlatformResponsive.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.rsp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64.rw,
            height: 64.rh,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.rsp),
            ),
            child: Icon(
              _getRoleIcon(),
              color: AppColors.primaryColor,
              size: 32.rsp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.rsp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14.rsp, color: Colors.grey[600]),
            ),
          ],
          SizedBox(height: 12.h),
          Container(
            padding: PlatformResponsive.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.rsp),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 12.rsp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProfileSections() {
    final sections = <Widget>[];

    switch (role) {
      case 'Artist':
        sections.addAll([
          _buildSection('Professional Information', [
            _buildField('Stage Name', profileData['stageName']),
            _buildField('Profession', profileData['profession']),
            _buildField('Category', profileData['category']),
          ]),
          _buildSection('Contact & Bio', [
            _buildField('Management Contact', profileData['managementContact']),
            _buildField('Bio', profileData['bio']),
          ]),
        ]);
        break;

      case 'Influencer':
        sections.addAll([
          _buildSection('Basic Information', [
            _buildField('Display Name', profileData['displayName']),
            _buildField('Niche', profileData['niche']),
            _buildField('Location', profileData['location']),
          ]),
          _buildSection('Platform Information', [
            _buildField('Primary Platform', profileData['primaryPlatform']),
            _buildField('Estimated Reach', profileData['estimatedReach']),
          ]),
          _buildSection('About', [_buildField('Bio', profileData['bio'])]),
        ]);
        break;

      case 'Radio Station':
        sections.addAll([
          _buildSection('Station Information', [
            _buildField('Station Name', profileData['stationName']),
            _buildField('Frequency', profileData['frequency']),
            _buildField('Coverage Area', profileData['coverageArea']),
          ]),
          _buildSection('Business Details', [
            _buildField('Media Type', profileData['mediaType']),
            _buildField(
              'Business Registration Number',
              profileData['businessRegNumber'],
            ),
          ]),
        ]);
        break;

      case 'TV Station':
        sections.addAll([
          _buildSection('Station Information', [
            _buildField('Station Name', profileData['stationName']),
            _buildField('Channel Number', profileData['channelNumber']),
            _buildField('Coverage Area', profileData['coverageArea']),
          ]),
          _buildSection('Business Details', [
            _buildField('Media Type', profileData['mediaType']),
            _buildField(
              'Business Registration Number',
              profileData['businessRegNumber'],
            ),
            _buildField('License Number', profileData['licenseNumber']),
          ]),
          _buildSection('Location', [
            _buildField('Studio Address', profileData['studioAddress']),
          ]),
        ]);
        break;

      case 'Media House':
        sections.addAll([
          _buildSection('Basic Information', [
            _buildField('Media Name', profileData['mediaName']),
            _buildField('Media Type', profileData['mediaType']),
            _buildField('Website', profileData['websiteUrl']),
          ]),
          _buildSection('Metrics', [
            _buildField(
              'Monthly Visitors',
              profileData['monthlyVisitors']?.toString(),
            ),
          ]),
          _buildSection('Social Media', [
            _buildField('Facebook', profileData['facebookHandle']),
            _buildField('Instagram', profileData['instagramHandle']),
            _buildField('TikTok', profileData['tiktokHandle']),
            _buildField('Twitter', profileData['twitterHandle']),
          ]),
        ]);
        break;

      case 'Advertiser':
        sections.addAll([
          _buildSection('Business Information', [
            _buildField('Business Name', profileData['businessName']),
            _buildField('Industry', profileData['industry']),
            _buildField('Business Address', profileData['businessAdress']),
            _buildField('Website', profileData['businessWebsite']),
          ]),
        ]);
        break;

      case 'Host':
        sections.addAll([
          _buildSection('Business Information', [
            _buildField('Business Name', profileData['businessName']),
            _buildField('Industry', profileData['industry']),
            _buildField('Business Address', profileData['businessAddress']),
            _buildField('Website', profileData['businessWebsite']),
          ]),
          _buildSection('Contact & Details', [
            _buildField('Telephone', profileData['telephoneNumber']),
            _buildField(
              'Signage Permit Number',
              profileData['signagePermitNumber'],
            ),
          ]),
        ]);
        break;

      case 'Screen / Billboard':
        sections.addAll([
          _buildSection('Host Information', [
            _buildField('Business Name', profileData['businessName']),
            _buildField('Industry', profileData['industry']),
            _buildField('Business Address', profileData['businessAddress']),
          ]),
          _buildSection('Contact & Details', [
            _buildField('Telephone', profileData['telephoneNumber']),
            _buildField('Website', profileData['businessWebsite']),
            _buildField(
              'Signage Permit Number',
              profileData['signagePermitNumber'],
            ),
          ]),
        ]);
        break;

      case 'Content Producer':
        sections.addAll([
          _buildSection('Business Information', [
            _buildField('Business Name', profileData['businessName']),
            _buildField('Business Address', profileData['businessAddress']),
            _buildField('Website', profileData['businessWebsite']),
          ]),
          _buildSection('Contact', [
            _buildField('Telephone', profileData['telephoneNumber']),
          ]),
          _buildSection('Production Details', [
            _buildField('Production Type', profileData['productionType']),
            _buildField('Content Type', profileData['contentType']),
            _buildField('Genre', profileData['genre']),
          ]),
        ]);
        break;
    }

    return sections;
  }

  Widget _buildSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.rsp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: PlatformResponsive.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.rsp),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: [...fields.map((field) => field).toList()]),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildField(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.rsp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value?.toString() ?? 'Not provided',
            style: TextStyle(
              fontSize: 14.rsp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (value != null) SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: authState.isInitialLoading
                ? null
                : () async {
                    if (role == 'Artist') {
                      await _handleArtistSignup(context, ref);
                    } else {
                      // TODO: Handle other roles
                      context.push('/signin');
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.rsp),
              ),
              elevation: 0,
            ),
            child: authState.isInitialLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Confirm & Continue',
                    style: TextStyle(
                      fontSize: 16.rsp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              side: BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.rsp),
              ),
            ),
            child: Text(
              'Edit Information',
              style: TextStyle(fontSize: 16.rsp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleArtistSignup(BuildContext context, WidgetRef ref) async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    try {
      // Build ArtistInfo from profileData
      final artistInfo = ArtistInfo(
        stageName: profileData['stageName'] ?? '',
        primaryProfession: profileData['profession'] ?? '',
        specialization: profileData['specialization'] ?? '',
        genres: List<String>.from(profileData['genre'] ?? []),
        yearsOfExperience:
            int.tryParse(profileData['yearsOfExperience']?.toString() ?? '0') ??
            0,
        numberOfProductions:
            int.tryParse(
              profileData['numberOfProductions']?.toString() ?? '0',
            ) ??
            0,
        availabilityType: profileData['availability'] ?? '',
        portfolioLink: profileData['portfolioLink'],
        managementType: profileData['whoManagesYou'] ?? 'SELF',
      );

      // Build SignUpRequest
      final signUpRequest = SignUpRequest(
        role: 'ARTIST',
        authProvider: 'INTERNAL',
        accountType: 'individual',
        artistInfo: artistInfo,
        name: profileData['name'] ?? '',
        emailAddress: profileData['email'] ?? '',
        phoneNumber: profileData['phoneNumber'] ?? '',
        password: profileData['password'] ?? '',
        country: 'Nigeria',
        state: profileData['state'] ?? '',
        city: profileData['city'] ?? '',
        address: profileData['address'] ?? '',
      );

      // Call signup
      await authNotifier.signupUser(signUpRequest);

      // Check if mounted before navigation
      if (!context.mounted) return;

      // Check result
      final authState = ref.read(authNotifierProvider);
      if (authState.isDataAvailable) {
        // Success - navigate to signin
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message ?? 'Signup successful!'),
            backgroundColor: Colors.green,
          ),
        );
        context.push('/signin');
      } else if (authState.message != null) {
        // Error - show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  IconData _getRoleIcon() {
    switch (role) {
      case 'Artist':
        return Icons.music_note;
      case 'Influencer':
        return Icons.person_pin;
      case 'Radio Station':
        return Icons.radio;
      case 'TV Station':
        return Icons.tv;
      case 'Media House':
        return Icons.business;
      case 'Advertiser':
        return Icons.campaign;
      case 'Screen / Billboard':
        return Icons.monitor;
      case 'Content Producer':
        return Icons.movie_creation;
      case 'Host':
        return Icons.business;
      default:
        return Icons.person;
    }
  }
}
