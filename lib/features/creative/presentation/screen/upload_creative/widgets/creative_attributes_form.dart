import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/widgets/option_picker_sheet.dart';

class CreativeAttributesForm extends StatefulWidget {
  final String? selectedType;
  final List<String> features;
  final List<String> tags;
  final ValueChanged<List<String>> onFeaturesChanged;
  final ValueChanged<List<String>> onTagsChanged;

  const CreativeAttributesForm({
    super.key,
    required this.selectedType,
    required this.features,
    required this.tags,
    required this.onFeaturesChanged,
    required this.onTagsChanged,
  });

  @override
  State<CreativeAttributesForm> createState() => _CreativeAttributesFormState();
}

class _CreativeAttributesFormState extends State<CreativeAttributesForm> {
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _featureController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
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
          _buildHeader(isDark),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel('Features (Optional)', isDark),
                SizedBox(height: 8.h),
                TextField(
                  controller: _featureController,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  decoration: _getInputDecoration(
                    hint: widget.features.isEmpty ? 'Select features...' : '',
                    isDark: isDark,
                    prefixIcon: widget.features.isNotEmpty
                        ? Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                            padding: EdgeInsets.only(left: 8.w, right: 4.w, top: 4.h, bottom: 4.h),
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 4.h,
                              children: widget.features.map((feature) {
                                return Chip(
                                  label: Text(feature, style: TextStyle(fontSize: 12.sp, color: Colors.white)),
                                  backgroundColor: AppColors.primaryColor,
                                  deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                                  onDeleted: () {
                                    final updated = List<String>.from(widget.features)..remove(feature);
                                    widget.onFeaturesChanged(updated);
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white54 : AppColors.grey500),
                      onPressed: () => _showFeaturePicker(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _showFeaturePicker(context),
                ),

                SizedBox(height: 24.h),

                // Tags Input
                _buildSectionLabel('Tags (Optional)', isDark),
                SizedBox(height: 8.h),
                TextField(
                  controller: _tagController,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  decoration: _getInputDecoration(
                    hint: widget.tags.isEmpty ? 'Select tags...' : '',
                    isDark: isDark,
                    prefixIcon: widget.tags.isNotEmpty
                        ? Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                            padding: EdgeInsets.only(left: 8.w, right: 4.w, top: 4.h, bottom: 4.h),
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 4.h,
                              children: widget.tags.map((tag) {
                                return Chip(
                                  label: Text(tag, style: TextStyle(fontSize: 12.sp, color: Colors.white)),
                                  backgroundColor: AppColors.primaryColor,
                                  deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                                  onDeleted: () {
                                    final updated = List<String>.from(widget.tags)..remove(tag);
                                    widget.onTagsChanged(updated);
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white54 : AppColors.grey500),
                      onPressed: () => _showTagPicker(context),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _showTagPicker(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : AppColors.grey200,
            width: 1,
          ),
        ),
      ),
      child: Text(
        'Creative Attributes',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _getInputDecoration({
    required String hint,
    required bool isDark,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: isDark ? Colors.white38 : AppColors.grey400,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : AppColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  Future<void> _showFeaturePicker(BuildContext context) async {
    List<String> options = [];
    final type = widget.selectedType?.toLowerCase() ?? '';
    
    if (type.contains('image')) {
      options = ['##HEADER##IMAGE FEATURES', 'HIGH_RESOLUTION', 'SOURCE_FILE', 'COMMERCIAL_USE', 'VECTOR_FILE', 'TRANSPARENT_BACKGROUND'];
    } else if (type.contains('video')) {
      options = ['##HEADER##VIDEO FEATURES', '1080P_RESOLUTION', '4K_RESOLUTION', 'SUBTITLES', 'BACKGROUND_MUSIC', 'MOTION_GRAPHICS', 'VOICE_OVER'];
    } else if (type.contains('audio')) {
      options = ['##HEADER##AUDIO FEATURES', 'HIGH_QUALITY_AUDIO', 'SEPARATED_TRACKS', 'COMMERCIAL_RIGHTS'];
    } else if (type.contains('document')) {
      options = ['##HEADER##DOCUMENT FEATURES', 'EDITABLE_FILE', 'PRINT_READY', 'CUSTOM_FONTS'];
    } else {
      options = ['##HEADER##STANDARD FEATURES', 'HIGH_RESOLUTION', 'SOURCE_FILE', 'COMMERCIAL_USE'];
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet(
        title: 'Select Features',
        options: options,
      ),
    );
    if (result != null) {
      if (!widget.features.contains(result)) {
        final updated = List<String>.from(widget.features)..add(result);
        widget.onFeaturesChanged(updated);
      }
    }
  }

  Future<void> _showTagPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Select Tags',
        options: [
          '##HEADER##CAMPAIGN',
          'PROMOTION',
          'AWARENESS',
          'LAUNCH',
          'DISCOUNT',
          'ANNOUNCEMENT',
          '##HEADER##STYLE',
          'MINIMALIST',
          'MODERN',
          'VINTAGE',
          'CORPORATE',
          '##HEADER##FORMAT',
          'SOCIAL_MEDIA',
          'PRINT',
          'WEB',
          'MOBILE',
        ],
      ),
    );
    if (result != null) {
      if (!widget.tags.contains(result)) {
        final updated = List<String>.from(widget.tags)..add(result);
        widget.onTagsChanged(updated);
      }
    }
  }
}
