import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/custom_multiselect_dropdown_field.dart';

class CreateAdSlotForm extends StatefulWidget {
  final String parentId;
  final String parentType;
  final String parentName;
  final VoidCallback onCancel;
  final Function(Map<String, dynamic>) onSubmit;

  const CreateAdSlotForm({
    super.key,
    required this.parentId,
    required this.parentType,
    required this.parentName,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  State<CreateAdSlotForm> createState() => _CreateAdSlotFormState();
}

class _CreateAdSlotFormState extends State<CreateAdSlotForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxRevisionsController = TextEditingController(text: '1');

  String? _selectedDuration;
  String? _selectedCoverageArea;
  String? _selectedAudienceSize;
  String? _selectedTimeWindow;
  List<String> _selectedPlatforms = [];
  List<String> _selectedContentTypes = [];
  List<String> _selectedFeatures = [];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _maxRevisionsController.dispose();
    super.dispose();
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
          // Ad Slot Title
          _buildLabel('Ad Slot Title', required: true),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'e.g. Premium Instagram Story Placement',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[400],
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ad slot title';
              }
              return null;
            },
          ),

          SizedBox(height: 24.h),

          // Partner Type (now selectable)
          CustomMultiselectDropdownField(
            label: 'Partner Type',
            hint: 'Select partner type',
            options: [
              {'label': 'Influencer', 'value': 'influencer'},
              {'label': 'Artist', 'value': 'artist'},
              {'label': 'Radio Station', 'value': 'radio_station'},
              {'label': 'TV Station', 'value': 'tv_station'},
              {'label': 'Media House', 'value': 'media_house'},
              {'label': 'Screen', 'value': 'screen'},
              {'label': 'Billboard', 'value': 'billboard'},
            ],
            initialValues: [widget.parentType],
            onChanged: (values) {
              // Partner type is pre-selected based on parent
            },
            isRequired: true,
          ),

          SizedBox(height: 24.h),

          // Platforms
          CustomMultiselectDropdownField(
            label: 'Platforms',
            hint: 'Select platform(s)',
            options: [
              {'label': 'Instagram', 'value': 'instagram'},
              {'label': 'TikTok', 'value': 'tiktok'},
              {'label': 'YouTube', 'value': 'youtube'},
              {'label': 'X (Twitter)', 'value': 'twitter'},
              {'label': 'Facebook', 'value': 'facebook'},
              {'label': 'Snapchat', 'value': 'snapchat'},
              {'label': 'LinkedIn', 'value': 'linkedin'},
            ],
            initialValues: _selectedPlatforms,
            onChanged: (values) => setState(() => _selectedPlatforms = values),
            isRequired: true,
          ),

          SizedBox(height: 24.h),

          // Content Types
          CustomMultiselectDropdownField(
            label: 'Content Types',
            hint: 'Select content type(s)',
            options: [
              {'label': 'Post', 'value': 'post'},
              {'label': 'Story', 'value': 'story'},
              {'label': 'Reel', 'value': 'reel'},
              {'label': 'Short Video', 'value': 'short_video'},
              {'label': 'Long Video', 'value': 'long_video'},
              {'label': 'Livestream', 'value': 'livestream'},
              {'label': 'Product Review', 'value': 'product_review'},
              {'label': 'Brand Mention', 'value': 'brand_mention'},
              {'label': 'Carousel', 'value': 'carousel'},
            ],
            initialValues: _selectedContentTypes,
            onChanged: (values) => setState(() => _selectedContentTypes = values),
            isRequired: true,
          ),

          SizedBox(height: 24.h),

          // Features
          CustomMultiselectDropdownField(
            label: 'Features',
            hint: 'Select feature(s)',
            options: [
              {'label': 'Link in Bio', 'value': 'link_in_bio'},
              {'label': 'Swipe Up', 'value': 'swipe_up'},
              {'label': 'Shoutout', 'value': 'shoutout'},
              {'label': 'Tagged Post', 'value': 'tagged_post'},
              {'label': 'Product Integration', 'value': 'product_integration'},
              {'label': 'Shopping Tag', 'value': 'shopping_tag'},
              {'label': 'Poll', 'value': 'poll'},
              {'label': 'Quiz', 'value': 'quiz'},
              {'label': 'Countdown', 'value': 'countdown'},
            ],
            initialValues: _selectedFeatures,
            onChanged: (values) => setState(() => _selectedFeatures = values),
            isRequired: true,
          ),

          SizedBox(height: 24.h),

          // Price
          _buildLabel('Price (NGN)', required: true),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),

          SizedBox(height: 24.h),

          // Duration
          _buildLabel('Duration', required: true),
          SizedBox(height: 8.h),
          _buildDropdown(
            'Select duration',
            _selectedDuration,
            ['7 days', '14 days', '30 days', '60 days', '90 days'],
            (value) => setState(() => _selectedDuration = value),
            isDark,
          ),

          SizedBox(height: 24.h),

          // Max Revisions
          _buildLabel('Max Revisions', required: true),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _maxRevisionsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: '1',
              filled: true,
              fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),

          SizedBox(height: 24.h),

          // Coverage Area
          _buildLabel('Coverage Area', required: true),
          SizedBox(height: 8.h),
          _buildDropdown(
            'Select coverage area',
            _selectedCoverageArea,
            ['Local', 'Regional', 'National', 'International'],
            (value) => setState(() => _selectedCoverageArea = value),
            isDark,
          ),

          SizedBox(height: 24.h),

          // Audience Size
          _buildLabel('Audience Size', required: true),
          SizedBox(height: 8.h),
          _buildDropdown(
            'Select audience size',
            _selectedAudienceSize,
            ['10k - 50k', '50k - 100k', '100k - 500k', '500k - 1M', '1M+'],
            (value) => setState(() => _selectedAudienceSize = value),
            isDark,
          ),

          SizedBox(height: 24.h),

          // Time Window
          _buildLabel('Time Window', required: true),
          SizedBox(height: 8.h),
          _buildDropdown(
            'Select time window',
            _selectedTimeWindow,
            ['Morning (6AM-12PM)', 'Afternoon (12PM-6PM)', 'Evening (6PM-12AM)', 'Night (12AM-6AM)', 'All Day'],
            (value) => setState(() => _selectedTimeWindow = value),
            isDark,
          ),

          SizedBox(height: 40.h),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                  side: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 16.w),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D82),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Create Slot',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledDropdown(String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white60 : Colors.grey[600],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? Colors.white38 : Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
    bool isDark,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.grey[400],
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
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
          color: isDark ? Colors.grey[300] : Colors.grey[700],
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

  void _handleSubmit() {
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

      final slotData = {
        'parentId': widget.parentId,
        'parentType': widget.parentType,
        'title': _titleController.text,
        'platforms': _selectedPlatforms,
        'contentTypes': _selectedContentTypes,
        'features': _selectedFeatures,
        'price': double.parse(_priceController.text),
        'duration': _selectedDuration,
        'maxRevisions': int.parse(_maxRevisionsController.text),
        'coverageArea': _selectedCoverageArea,
        'audienceSize': _selectedAudienceSize,
        'timeWindow': _selectedTimeWindow,
      };

      widget.onSubmit(slotData);
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
