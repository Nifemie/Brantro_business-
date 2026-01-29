import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/service/session_service.dart';
import '../../data/models/create_ad_slot_request.dart';
import '../../../KYC/logic/kyc_provider.dart';

class CreateAdSlotScreen extends ConsumerStatefulWidget {
  const CreateAdSlotScreen({super.key});

  @override
  ConsumerState<CreateAdSlotScreen> createState() => _CreateAdSlotScreenState();
}

class _CreateAdSlotScreenState extends ConsumerState<CreateAdSlotScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _priceController = TextEditingController();
  final _audienceSizeController = TextEditingController();
  final _timeWindowController = TextEditingController();
  
  // Form values
  String? _partnerType;
  String? _platform;
  String? _contentType;
  String? _duration;
  String? _coverageArea;
  int _maxRevisions = 1;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkKycAndLoadRole();
  }

  Future<void> _checkKycAndLoadRole() async {
    final userJson = await SessionService.getUser();
    if (userJson != null) {
      final role = userJson['role']?.toString().toUpperCase();
      
      // Check if this role requires KYC
      final requiresKyc = _roleRequiresKyc(role);
      
      if (requiresKyc) {
        // Fetch KYC status from API using provider
        final kycStatus = await ref.read(kycProvider.notifier).getKycStatusString();
        
        if (kycStatus != 'APPROVED') {
          // Navigate to KYC gate
          if (mounted) {
            context.go('/kyc-gate', extra: {
              'requiredFor': 'creating ad slots',
              'returnRoute': '/create-ad-slot',
            });
          }
          return;
        }
      }
      
      setState(() {
        _partnerType = role;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _roleRequiresKyc(String? role) {
    if (role == null) return false;
    
    // Roles that require KYC before selling
    const kycRequiredRoles = [
      'INFLUENCER',
      'ARTIST',
      'RADIO_STATION',
      'TV_STATION',
      'MEDIA_HOUSE',
      'HOST',
      'DESIGNER',
    ];
    
    return kycRequiredRoles.contains(role);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _audienceSizeController.dispose();
    _timeWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Create Ad Slot', style: AppTexts.h3()),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text('Create', style: AppTexts.buttonMedium(color: AppColors.primaryColor)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Partner Type (Read-only)
            _buildSectionTitle('Seller Type'),
            _buildReadOnlyField(_partnerType ?? 'Unknown'),
            SizedBox(height: 24.h),

            // Platform
            _buildSectionTitle('Platform *'),
            _buildPlatformDropdown(),
            SizedBox(height: 24.h),

            // Content Type
            if (_platform != null) ...[
              _buildSectionTitle('Content Type *'),
              _buildContentTypeDropdown(),
              SizedBox(height: 24.h),
            ],

            // Price
            _buildSectionTitle('Price (NGN) *'),
            _buildPriceField(),
            SizedBox(height: 24.h),

            // Duration
            _buildSectionTitle('Duration *'),
            _buildDurationDropdown(),
            SizedBox(height: 24.h),

            // Audience Size
            _buildSectionTitle('Audience Size *'),
            _buildTextField(
              controller: _audienceSizeController,
              hint: 'e.g., 200k followers, 500k listeners',
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            SizedBox(height: 24.h),

            // Coverage Area
            _buildSectionTitle('Coverage Area'),
            _buildCoverageAreaDropdown(),
            SizedBox(height: 24.h),

            // Max Revisions
            _buildSectionTitle('Max Revisions'),
            _buildRevisionsCounter(),
            SizedBox(height: 24.h),

            // Time Window
            _buildSectionTitle('Time Window'),
            _buildTextField(
              controller: _timeWindowController,
              hint: 'e.g., Anytime, Weekdays only',
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(title, style: AppTexts.h4()),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Text(value, style: AppTexts.bodyMedium(color: AppColors.grey600)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTexts.bodyMedium(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: validator,
    );
  }

  Widget _buildPlatformDropdown() {
    final platforms = _getPlatformsForPartnerType();
    
    return DropdownButtonFormField<String>(
      value: _platform,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      hint: Text('Select platform', style: AppTexts.bodyMedium(color: AppColors.grey400)),
      items: platforms.map((platform) {
        return DropdownMenuItem(
          value: platform,
          child: Text(platform, style: AppTexts.bodyMedium()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _platform = value;
          _contentType = null; // Reset content type when platform changes
        });
      },
      validator: (value) => value == null ? 'Please select a platform' : null,
    );
  }

  Widget _buildContentTypeDropdown() {
    final contentTypes = _getContentTypesForPlatform();
    
    return DropdownButtonFormField<String>(
      value: _contentType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      hint: Text('Select content type', style: AppTexts.bodyMedium(color: AppColors.grey400)),
      items: contentTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type, style: AppTexts.bodyMedium()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _contentType = value;
        });
      },
      validator: (value) => value == null ? 'Please select a content type' : null,
    );
  }

  Widget _buildDurationDropdown() {
    final durations = _getDurationsForPlatform();
    
    return DropdownButtonFormField<String>(
      value: _duration,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      hint: Text('Select duration', style: AppTexts.bodyMedium(color: AppColors.grey400)),
      items: durations.map((duration) {
        return DropdownMenuItem(
          value: duration,
          child: Text(duration, style: AppTexts.bodyMedium()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _duration = value;
        });
      },
      validator: (value) => value == null ? 'Please select a duration' : null,
    );
  }

  Widget _buildCoverageAreaDropdown() {
    final areas = ['Abuja', 'Lagos', 'Port Harcourt', 'Kano', 'Nationwide'];
    
    return DropdownButtonFormField<String>(
      value: _coverageArea,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      hint: Text('Select coverage area', style: AppTexts.bodyMedium(color: AppColors.grey400)),
      items: areas.map((area) {
        return DropdownMenuItem(
          value: area,
          child: Text(area, style: AppTexts.bodyMedium()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _coverageArea = value;
        });
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      style: AppTexts.bodyMedium(),
      decoration: InputDecoration(
        prefixText: '₦ ',
        prefixStyle: AppTexts.h3(),
        hintText: '0',
        hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Price is required';
        if (double.tryParse(value!) == null) return 'Enter a valid number';
        return null;
      },
    );
  }

  Widget _buildRevisionsCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Text('Number of revisions allowed', style: AppTexts.bodyMedium()),
          const Spacer(),
          IconButton(
            onPressed: () {
              if (_maxRevisions > 0) {
                setState(() => _maxRevisions--);
              }
            },
            icon: Icon(Icons.remove_circle_outline, color: AppColors.grey600),
          ),
          Text('$_maxRevisions', style: AppTexts.h3()),
          IconButton(
            onPressed: () {
              setState(() => _maxRevisions++);
            },
            icon: Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  List<String> _getPlatformsForPartnerType() {
    switch (_partnerType) {
      case 'INFLUENCER':
        return ['Instagram', 'TikTok', 'YouTube', 'Twitter', 'Facebook'];
      case 'RADIO_STATION':
        return ['Radio'];
      case 'TV_STATION':
        return ['TV'];
      case 'ARTIST':
        return ['Music Video', 'Live Performance', 'Social Media'];
      default:
        return ['Instagram', 'TikTok', 'Radio', 'TV', 'Website', 'Billboard'];
    }
  }

  List<String> _getContentTypesForPlatform() {
    switch (_platform) {
      case 'Instagram':
      case 'TikTok':
      case 'Facebook':
        return ['Post', 'Story', 'Reel'];
      case 'YouTube':
        return ['Video', 'Short', 'Live Stream'];
      case 'Radio':
        return ['Jingle', 'Interview', 'Mention'];
      case 'TV':
        return ['Commercial', 'Interview', 'Banner'];
      default:
        return ['Post', 'Story', 'Banner'];
    }
  }

  List<String> _getDurationsForPlatform() {
    switch (_platform) {
      case 'Instagram':
      case 'TikTok':
      case 'Facebook':
        return ['24hrs', '48hrs', '7days', '30days'];
      case 'Radio':
      case 'TV':
        return ['30sec', '60sec', '2min', '5min'];
      default:
        return ['24hrs', '7days', '30days'];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit to API
      final request = CreateAdSlotRequest(
        partnerType: _partnerType!,
        platform: _platform!,
        contentType: _contentType!,
        price: double.parse(_priceController.text),
        duration: _duration!,
        maxRevisions: _maxRevisions,
        coverageArea: _coverageArea,
        audienceSize: _audienceSizeController.text,
        timeWindow: _timeWindowController.text.isEmpty ? null : _timeWindowController.text,
      );

      // Show success message for now
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ad Slot Created! (API integration pending)'),
          backgroundColor: AppColors.primaryColor,
        ),
      );

      // Navigate back
      context.pop();
    }
  }
}
