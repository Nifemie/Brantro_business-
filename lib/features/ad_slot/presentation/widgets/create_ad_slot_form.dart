import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/custom_multiselect_dropdown_field.dart';
import 'package:brantro_business/core/service/session_service.dart';
import 'package:brantro_business/core/data/repositories/file_repository.dart';
import 'package:brantro_business/core/constants/nigerian_locations.dart';
import '../../data/models/ad_slot_constants.dart';
import '../../data/models/ad_slot_model.dart';
import 'ad_slot_editor_toolbar.dart';
import 'ad_slot_dropdown_field.dart';

class CreateAdSlotForm extends ConsumerStatefulWidget {
  final String parentId;
  final String parentType;
  final String parentName;
  final AdSlotModel? existingSlot;
  final VoidCallback onCancel;
  final Function(Map<String, dynamic>) onSubmit;

  const CreateAdSlotForm({
    super.key,
    required this.parentId,
    required this.parentType,
    required this.parentName,
    this.existingSlot,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  ConsumerState<CreateAdSlotForm> createState() => _CreateAdSlotFormState();
}

class _CreateAdSlotFormState extends ConsumerState<CreateAdSlotForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxRevisionsController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();
  final _riderRequirementsController = TextEditingController();

  // Broadcast specific
  final _maxSlotsPerBandController = TextEditingController(text: '10');

  // Screen specific
  final _loopDurationController = TextEditingController(text: '60');
  final _spotDurationController = TextEditingController(text: '10');
  final _maxSpotsController = TextEditingController(text: '6');
  final _operatingHoursController = TextEditingController(text: '06:00-23:00');

  String? _selectedPartnerType;
  String? _selectedOfferingType = 'DIGITAL_ENDORSEMENT';
  String? _selectedTimeBand = 'PRIME_TIME';
  String? _selectedDuration;
  String? _selectedCoverageArea;
  String? _selectedAudienceSize;
  String? _selectedTimeWindow;
  String? _selectedAdFormat;
  String? _selectedState;
  String? _selectedCity;

  List<String> _selectedPlatforms = [];
  List<String> _selectedContentTypes = [];
  List<String> _selectedFeatures = [];
  List<String> _sampleTracks = [];
  List<String> _showReels = [];

  bool _isUploadingAudio = false;
  bool _isUploadingVideo = false;
  bool _isSubmitting = false;

  static const List<String> _validPartnerTypes = [
    'INFLUENCER',
    'ARTIST',
    'RADIO_STATION',
    'TV_STATION',
    'MEDIA_HOUSE',
    'SCREEN',
    'BILLBOARD',
    'VEHICLE',
    'WALL',
  ];

  static const List<String> _offeringTypes = [
    'DIGITAL_ENDORSEMENT',
    'PHYSICAL_APPEARANCE',
    'SPONSORED_CONTENT',
  ];

  static const List<String> _timeBands = [
    'MORNING_DRIVE',
    'MID_DAY',
    'PRIME_TIME',
    'LATE_NIGHT',
  ];

  static const List<String> _coverageAreas = [
    'National',
    'State',
    'City',
    'Online / Global',
  ];

  String _normalizePartnerType(String? input) {
    if (input == null || input.isEmpty) return 'INFLUENCER';
    final normalized = input
        .trim()
        .toUpperCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');
    if (_validPartnerTypes.contains(normalized)) return normalized;
    if (normalized.contains('ARTIST') || normalized.contains('MUSIC')) return 'ARTIST';
    if (normalized.contains('INFLUENCER') || normalized.contains('CREATOR')) return 'INFLUENCER';
    if (normalized.contains('RADIO')) return 'RADIO_STATION';
    if (normalized.contains('TV')) return 'TV_STATION';
    if (normalized.contains('MEDIA')) return 'MEDIA_HOUSE';
    if (normalized.contains('BILLBOARD')) return 'BILLBOARD';
    if (normalized.contains('VEHICLE') || normalized.contains('CAR') || normalized.contains('BUS')) return 'VEHICLE';
    if (normalized.contains('WALL')) return 'WALL';
    if (normalized.contains('SCREEN')) return 'SCREEN';
    return 'INFLUENCER';
  }

  @override
  void initState() {
    super.initState();
    _selectedPartnerType = _normalizePartnerType(widget.parentType);
    _loadUserRole();
    _prefillExistingData();
  }

  void _prefillExistingData() {
    final slot = widget.existingSlot;
    if (slot == null) return;

    _titleController.text = slot.title ?? slot.slotNumber;
    _priceController.text = slot.price.toString();
    _maxRevisionsController.text = slot.maxRevisions?.toString() ?? '1';
    _descriptionController.text = slot.description ?? '';

    _selectedPartnerType = _normalizePartnerType(slot.partnerType ?? widget.parentType);
    _selectedDuration = slot.duration;
    _selectedCoverageArea = slot.coverageArea;
    _selectedAudienceSize = slot.audienceSize;
    _selectedTimeWindow = slot.timeWindow;
    _selectedAdFormat = slot.adFormat;

    if (slot.platforms != null) {
      _selectedPlatforms = List.from(slot.platforms!);
    }
    if (slot.contentTypes != null) {
      _selectedContentTypes = List.from(slot.contentTypes!);
    }
    if (slot.features != null && slot.features!.isNotEmpty) {
      _selectedFeatures = List.from(slot.features!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _maxRevisionsController.dispose();
    _descriptionController.dispose();
    _riderRequirementsController.dispose();
    _maxSlotsPerBandController.dispose();
    _loopDurationController.dispose();
    _spotDurationController.dispose();
    _maxSpotsController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final user = await SessionService.getUser();
    if (user != null && user['role'] != null) {
      if (mounted && widget.existingSlot == null) {
        setState(() {
          _selectedPartnerType = _normalizePartnerType(user['role'].toString());
        });
      }
    }
  }

  bool get _isInfluencerOrArtist {
    final t = _selectedPartnerType ?? '';
    return t == 'INFLUENCER' || t == 'ARTIST';
  }

  bool get _isBroadcast {
    final t = _selectedPartnerType ?? '';
    return t == 'RADIO_STATION' || t == 'TV_STATION' || t == 'MEDIA_HOUSE';
  }

  bool get _isScreen {
    final t = _selectedPartnerType ?? '';
    return t == 'SCREEN';
  }

  Future<void> _pickAndUploadAudio() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _isUploadingAudio = true);
        final fileRepo = ref.read(fileRepositoryProvider);
        final uploadedUrl = await fileRepo.uploadFile(
          result.files.single.path!,
          prefix: 'sample-tracks',
        );
        setState(() {
          _sampleTracks.add(uploadedUrl);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Audio sample uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAudio = false);
    }
  }

  Future<void> _pickAndUploadVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _isUploadingVideo = true);
        final fileRepo = ref.read(fileRepositoryProvider);
        final uploadedUrl = await fileRepo.uploadFile(
          result.files.single.path!,
          prefix: 'show-reels',
        );
        setState(() {
          _showReels.add(uploadedUrl);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Show reel video uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingVideo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Basic Information
          Text(
            'BASIC INFORMATION',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white60 : Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 16.h),

          // Slot Title
          _buildLabel('Slot Title', required: true),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _titleController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: _inputDecoration('e.g., Prime Time Instagram Reel', isDark),
            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
          ),

          SizedBox(height: 24.h),

          // Partner Type Dropdown
          _buildLabel('Partner / Category Type', required: true),
          SizedBox(height: 8.h),
          AdSlotDropdownField(
            hint: 'Select Category',
            value: _selectedPartnerType,
            items: _validPartnerTypes,
            onChanged: (value) {
              setState(() {
                _selectedPartnerType = value;
              });
            },
          ),

          SizedBox(height: 24.h),

          // Offering Type for Influencers / Artists
          if (_isInfluencerOrArtist) ...[
            _buildLabel('Offering Type', required: true),
            SizedBox(height: 8.h),
            AdSlotDropdownField(
              hint: 'Select Offering Type',
              value: _selectedOfferingType,
              items: _offeringTypes,
              onChanged: (value) => setState(() => _selectedOfferingType = value),
            ),
            SizedBox(height: 24.h),

            // Rider requirements if Physical Appearance
            if (_selectedOfferingType == 'PHYSICAL_APPEARANCE') ...[
              _buildLabel('Rider Requirements (Hospitality / Security / Travel)'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _riderRequirementsController,
                maxLines: 3,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: _inputDecoration('Specify accommodation, transport, sound check, or green room needs...', isDark),
              ),
              SizedBox(height: 24.h),
            ],
          ],

          // Broadcast Grid specific options (Radio / TV / Media House)
          if (_isBroadcast) ...[
            _buildLabel('Broadcast Time Band', required: true),
            SizedBox(height: 8.h),
            AdSlotDropdownField(
              hint: 'Select Time Band',
              value: _selectedTimeBand,
              items: _timeBands,
              onChanged: (value) => setState(() => _selectedTimeBand = value),
            ),
            SizedBox(height: 16.h),
            _buildLabel('Max Slots Per Band'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _maxSlotsPerBandController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _inputDecoration('e.g. 10', isDark),
            ),
            SizedBox(height: 24.h),
          ],

          // Digital Screen specific options
          if (_isScreen) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Loop Duration (s)'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _loopDurationController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: _inputDecoration('60', isDark),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Spot Duration (s)'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _spotDurationController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: _inputDecoration('10', isDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Max Spots'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _maxSpotsController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: _inputDecoration('6', isDark),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Operating Hours'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _operatingHoursController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: _inputDecoration('06:00-23:00', isDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],

          // Platforms Multiselect
          CustomMultiselectDropdownField(
            label: 'Target Platforms',
            hint: 'Select platforms',
            options: AdSlotConstants.platformOptions,
            initialValues: _selectedPlatforms,
            onChanged: (values) => setState(() => _selectedPlatforms = values),
          ),

          SizedBox(height: 24.h),

          // Content Types Multiselect
          CustomMultiselectDropdownField(
            label: 'Content Types',
            hint: 'Select content types',
            options: AdSlotConstants.contentTypeOptions,
            initialValues: _selectedContentTypes,
            onChanged: (values) => setState(() => _selectedContentTypes = values),
          ),

          SizedBox(height: 24.h),

          // Features Multiselect
          CustomMultiselectDropdownField(
            label: 'Features',
            hint: 'Select features',
            options: AdSlotConstants.featureOptions,
            initialValues: _selectedFeatures,
            onChanged: (values) => setState(() => _selectedFeatures = values),
          ),

          SizedBox(height: 24.h),

          // Price & Revisions
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Price (NGN)', required: true),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _priceController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration('0', isDark),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Max Revisions'),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _maxRevisionsController,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('1', isDark),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Description Editor Block
          _buildLabel('Description'),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                const AdSlotEditorToolbar(),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Provide a detailed description of this advertisement slot...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.w),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Media Samples Upload (Show Reels & Sample Tracks)
          if (_isInfluencerOrArtist) ...[
            Text(
              'MEDIA SAMPLES & SHOW REELS',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 14.h),

            // Premium Video Show Reels Card
            _buildVideoReelsUploader(isDark),

            SizedBox(height: 16.h),

            // Premium Audio Tracks Card
            _buildAudioTracksUploader(isDark),

            SizedBox(height: 24.h),
          ],

          // Duration & Audience Size
          _buildLabel('Duration', required: true),
          SizedBox(height: 8.h),
          AdSlotDropdownField(
            hint: 'Select duration',
            value: _selectedDuration,
            items: const ['24 hours', '3 days', '7 days', '14 days', '30 days', '60 days', '90 days'],
            onChanged: (value) => setState(() => _selectedDuration = value),
          ),

          SizedBox(height: 24.h),

          _buildLabel('Audience Size', required: true),
          SizedBox(height: 8.h),
          AdSlotDropdownField(
            hint: 'Select audience size',
            value: _selectedAudienceSize,
            items: const ['10k - 50k', '50k - 100k', '100k - 500k', '500k - 1M', '1M+'],
            onChanged: (value) => setState(() => _selectedAudienceSize = value),
          ),

          SizedBox(height: 24.h),

          _buildLabel('Time Window', required: true),
          SizedBox(height: 8.h),
          AdSlotDropdownField(
            hint: 'Select time window',
            value: _selectedTimeWindow,
            items: const ['Morning (6AM-12PM)', 'Afternoon (12PM-6PM)', 'Evening (6PM-12AM)', 'Night (12AM-6AM)', 'All Day'],
            onChanged: (value) => setState(() => _selectedTimeWindow = value),
          ),

          SizedBox(height: 24.h),

          _buildLabel('Coverage Area', required: true),
          SizedBox(height: 8.h),
          AdSlotDropdownField(
            hint: 'Select coverage area',
            value: _selectedCoverageArea,
            items: _coverageAreas,
            onChanged: (value) {
              setState(() {
                _selectedCoverageArea = value;
                if (value != 'State' && value != 'City') {
                  _selectedState = null;
                  _selectedCity = null;
                }
              });
            },
          ),

          if (_selectedCoverageArea == 'State' || _selectedCoverageArea == 'City') ...[
            SizedBox(height: 24.h),
            _buildLabel('Select State', required: true),
            SizedBox(height: 8.h),
            AdSlotDropdownField(
              hint: 'Select Nigerian State',
              value: _selectedState,
              items: NigerianLocations.states,
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedCity = null;
                });
              },
            ),
          ],

          if (_selectedCoverageArea == 'City' && _selectedState != null) ...[
            SizedBox(height: 24.h),
            _buildLabel('Select City', required: true),
            SizedBox(height: 8.h),
            AdSlotDropdownField(
              hint: 'Select City',
              value: _selectedCity,
              items: NigerianLocations.getCitiesForState(_selectedState!),
              onChanged: (value) => setState(() => _selectedCity = value),
            ),
          ],

          SizedBox(height: 40.h),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: _isSubmitting ? null : widget.onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: const Text('Cancel'),
              ),
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          SizedBox(width: 10.w),
                          const Text('Creating Slot...'),
                        ],
                      )
                    : const Text('Create Advertisement Slot'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              ]
            : [],
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPlatforms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one platform')),
        );
        return;
      }
      if (_selectedContentTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one content type')),
        );
        return;
      }
      if (_selectedFeatures.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one feature')),
        );
        return;
      }
      if (_selectedCoverageArea == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a coverage area')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final partnerTypeFormatted = _normalizePartnerType(_selectedPartnerType ?? widget.parentType);
      final parsedLocationId = int.tryParse(widget.parentId);

      final slotData = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'partnerType': partnerTypeFormatted,
        'platforms': _selectedPlatforms.map((p) => p.trim()).toList(),
        'contentTypes': _selectedContentTypes,
        'features': _selectedFeatures,
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'duration': _selectedDuration ?? '7days',
        'maxRevisions': int.tryParse(_maxRevisionsController.text.trim()) ?? 1,
        'coverageArea': _selectedCoverageArea,
        'audienceSize': _selectedAudienceSize ?? '10k - 50k',
        'timeWindow': _selectedTimeWindow ?? 'Flexible',
        'adFormat': _selectedAdFormat ?? 'Image Post',
        'selectedCities': _selectedCity != null ? [_selectedCity!] : [],
        'selectedStates': _selectedState != null ? [_selectedState!] : [],
        'thumbnailUrl': '',
      };

      // Offering types & Rider requirements
      if (_isInfluencerOrArtist) {
        slotData['offeringType'] = _selectedOfferingType ?? 'DIGITAL_ENDORSEMENT';
        if (_selectedOfferingType == 'PHYSICAL_APPEARANCE') {
          slotData['riderRequirements'] = _riderRequirementsController.text.trim();
        }
        if (_sampleTracks.isNotEmpty) {
          slotData['sampleTracks'] = _sampleTracks;
        }
        if (_showReels.isNotEmpty) {
          slotData['showReels'] = _showReels;
        }
      }

      // Broadcast fields
      if (_isBroadcast) {
        slotData['timeBand'] = _selectedTimeBand ?? 'PRIME_TIME';
        slotData['maxSlotsPerBand'] = int.tryParse(_maxSlotsPerBandController.text.trim()) ?? 10;
      }

      // Screen fields
      if (_isScreen) {
        slotData['loopDurationSeconds'] = int.tryParse(_loopDurationController.text.trim()) ?? 60;
        slotData['spotDurationSeconds'] = int.tryParse(_spotDurationController.text.trim()) ?? 10;
        slotData['maxSpots'] = int.tryParse(_maxSpotsController.text.trim()) ?? 6;
        slotData['operatingHours'] = _operatingHoursController.text.trim();
      }

      if (parsedLocationId != null && parsedLocationId > 0) {
        slotData['locationId'] = parsedLocationId;
      }

      try {
        await widget.onSubmit(slotData);
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  Widget _buildVideoReelsUploader(bool isDark) {
    const primaryColor = AppColors.primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.video_library_rounded, size: 20.sp, color: primaryColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Show Reels',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Past brand campaigns, reels, or video portfolio',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (_showReels.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_showReels.length} added',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),

          // Upload Drop Card
          InkWell(
            onTap: _isUploadingVideo ? null : _pickAndUploadVideo,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: primaryColor.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  if (_isUploadingVideo) ...[
                    SizedBox(
                      width: 28.w,
                      height: 28.w,
                      child: const CircularProgressIndicator(strokeWidth: 2.5, color: primaryColor),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Uploading Video Reel...',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: primaryColor),
                    ),
                  ] else ...[
                    Icon(Icons.cloud_upload_outlined, size: 30.sp, color: primaryColor),
                    SizedBox(height: 6.h),
                    Text(
                      'Tap to Upload Video Reel',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Supports MP4, MOV, WEBM (Max 50MB)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white38 : Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Uploaded Reels List
          if (_showReels.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Column(
              children: _showReels.asMap().entries.map((entry) {
                final idx = entry.key;
                final url = entry.value;
                final fileName = url.split('/').last.split('?').first;
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(Icons.play_arrow_rounded, size: 18.sp, color: const Color(0xFF10B981)),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Show Reel #${idx + 1}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              fileName.length > 28 ? '${fileName.substring(0, 25)}...' : fileName,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark ? Colors.white38 : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, size: 20.sp, color: Colors.red[400]),
                        onPressed: () => setState(() => _showReels.remove(url)),
                        tooltip: 'Remove Reel',
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAudioTracksUploader(bool isDark) {
    const audioColor = Color(0xFF10B981);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: audioColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.graphic_eq_rounded, size: 20.sp, color: audioColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Sample Tracks',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Voiceovers, music samples, drops, or jingles',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (_sampleTracks.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: audioColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_sampleTracks.length} added',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: audioColor),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),

          // Upload Drop Card
          InkWell(
            onTap: _isUploadingAudio ? null : _pickAndUploadAudio,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: audioColor.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  if (_isUploadingAudio) ...[
                    SizedBox(
                      width: 28.w,
                      height: 28.w,
                      child: const CircularProgressIndicator(strokeWidth: 2.5, color: audioColor),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Uploading Audio Clip...',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: audioColor),
                    ),
                  ] else ...[
                    Icon(Icons.audiotrack_rounded, size: 30.sp, color: audioColor),
                    SizedBox(height: 6.h),
                    Text(
                      'Tap to Upload Audio Clip',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Supports MP3, WAV, AAC, M4A (Max 25MB)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white38 : Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Uploaded Audio List
          if (_sampleTracks.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Column(
              children: _sampleTracks.asMap().entries.map((entry) {
                final idx = entry.key;
                final url = entry.value;
                final fileName = url.split('/').last.split('?').first;
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: audioColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(Icons.music_note_rounded, size: 18.sp, color: audioColor),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sample Track #${idx + 1}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              fileName.length > 28 ? '${fileName.substring(0, 25)}...' : fileName,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark ? Colors.white38 : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, size: 20.sp, color: Colors.red[400]),
                        onPressed: () => setState(() => _sampleTracks.remove(url)),
                        tooltip: 'Remove Track',
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
