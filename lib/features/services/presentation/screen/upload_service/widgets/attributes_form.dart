import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/widgets/option_picker_sheet.dart';

class AttributesForm extends StatefulWidget {
  final List<String> features;
  final List<String> requirements;
  final String? selectedDeliveryFormat;
  final List<String> coverageAreas;
  final List<String> tags;
  final String? selectedType;
  final ValueChanged<List<String>> onFeaturesChanged;
  final ValueChanged<List<String>> onRequirementsChanged;
  final ValueChanged<String?> onDeliveryFormatChanged;
  final ValueChanged<List<String>> onCoverageAreasChanged;
  final ValueChanged<List<String>> onTagsChanged;

  const AttributesForm({
    super.key,
    required this.features,
    required this.requirements,
    required this.selectedDeliveryFormat,
    required this.coverageAreas,
    required this.tags,
    this.selectedType,
    required this.onFeaturesChanged,
    required this.onRequirementsChanged,
    required this.onDeliveryFormatChanged,
    required this.onCoverageAreasChanged,
    required this.onTagsChanged,
  });

  @override
  State<AttributesForm> createState() => _AttributesFormState();
}

class _AttributesFormState extends State<AttributesForm> {
  final _coverageController = TextEditingController();
  final _tagController = TextEditingController();
  final _featuresController = TextEditingController();
  final _requirementsController = TextEditingController();

  @override
  void dispose() {
    _coverageController.dispose();
    _tagController.dispose();
    _featuresController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _addCoverageArea() {
    final text = _coverageController.text.trim();
    if (text.isNotEmpty && !widget.coverageAreas.contains(text)) {
      final updated = List<String>.from(widget.coverageAreas)..add(text);
      widget.onCoverageAreasChanged(updated);
      _coverageController.clear();
    }
  }

  void _addFeature() {
    final text = _featuresController.text.trim();
    if (text.isNotEmpty && !widget.features.contains(text)) {
      final updated = List<String>.from(widget.features)..add(text);
      widget.onFeaturesChanged(updated);
      _featuresController.clear();
    }
  }

  void _addRequirement() {
    final text = _requirementsController.text.trim();
    if (text.isNotEmpty && !widget.requirements.contains(text)) {
      final updated = List<String>.from(widget.requirements)..add(text);
      widget.onRequirementsChanged(updated);
      _requirementsController.clear();
    }
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty) {
      final formattedText = text.startsWith('#') ? text : '#$text';
      if (!widget.tags.contains(formattedText)) {
        final updated = List<String>.from(widget.tags)..add(formattedText);
        widget.onTagsChanged(updated);
        _tagController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Specifications & Attributes', isDark),
        SizedBox(height: 16.h),
        
        _buildDropdownField(
          context: context,
          label: 'Delivery Formats (Primary Format) *',
          value: widget.selectedDeliveryFormat,
          hint: 'Select formats...',
          onTap: () => _showFormatPicker(context),
          isDark: isDark,
        ),
        
        SizedBox(height: 16.h),
        
        // Coverage Areas Input & Chips
        _buildSectionLabel('Coverage Areas (Optional)', isDark),
        SizedBox(height: 8.h),
        TextField(
          controller: _coverageController,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: _getInputDecoration(
            hint: widget.coverageAreas.isEmpty ? 'Type and press enter to add areas...' : '',
            isDark: isDark,
            prefixIcon: widget.coverageAreas.isEmpty
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: widget.coverageAreas.map((area) {
                        return Chip(
                          label: Text(area, style: TextStyle(fontSize: 12.sp)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            final updated = List<String>.from(widget.coverageAreas)..remove(area);
                            widget.onCoverageAreasChanged(updated);
                          },
                        );
                      }).toList(),
                    ),
                  ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 24.h,
                  width: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white60 : Colors.grey[600]),
                  onPressed: () => _showCoverageAreaPicker(context),
                ),
              ],
            ),
          ),
          onSubmitted: (_) => _addCoverageArea(),
        ),
        
        SizedBox(height: 16.h),
        
        // Tags Input & Chips
        _buildSectionLabel('Tags (Optional)', isDark),
        SizedBox(height: 8.h),
        TextField(
          controller: _tagController,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: _getInputDecoration(
            hint: widget.tags.isEmpty ? 'e.g. branding, logodesign...' : '',
            isDark: isDark,
            prefixIcon: widget.tags.isEmpty
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: widget.tags.map((tag) {
                        return Chip(
                          label: Text(tag, style: TextStyle(fontSize: 12.sp)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            final updated = List<String>.from(widget.tags)..remove(tag);
                            widget.onTagsChanged(updated);
                          },
                        );
                      }).toList(),
                    ),
                  ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 24.h,
                  width: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white60 : Colors.grey[600]),
                  onPressed: () => _showTagPicker(context),
                ),
              ],
            ),
          ),
          onSubmitted: (_) => _addTag(),
        ),
        
        SizedBox(height: 16.h),
        
        // Features Input & Chips
        _buildSectionLabel('Features (Optional)', isDark),
        SizedBox(height: 8.h),
        TextField(
          controller: _featuresController,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
          decoration: _getInputDecoration(
            hint: widget.features.isEmpty ? 'e.g. 4 Revisions, Source File...' : '',
            isDark: isDark,
            prefixIcon: widget.features.isEmpty
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: widget.features.map((feature) {
                        return Chip(
                          label: Text(feature, style: TextStyle(fontSize: 12.sp)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            final updated = List<String>.from(widget.features)..remove(feature);
                            widget.onFeaturesChanged(updated);
                          },
                        );
                      }).toList(),
                    ),
                  ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 24.h,
                  width: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white60 : Colors.grey[600]),
                  onPressed: () => _showFeaturePicker(context),
                ),
              ],
            ),
          ),
          onSubmitted: (_) => _addFeature(),
        ),
        
        SizedBox(height: 16.h),
        
        // Requirements Input & Chips
        _buildSectionLabel('Requirements (Optional)', isDark),
        SizedBox(height: 8.h),
        TextField(
          controller: _requirementsController,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
          decoration: _getInputDecoration(
            hint: widget.requirements.isEmpty ? 'Describe what you need from the client...' : '',
            isDark: isDark,
            prefixIcon: widget.requirements.isEmpty
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: widget.requirements.map((req) {
                        return Chip(
                          label: Text(req, style: TextStyle(fontSize: 12.sp)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            final updated = List<String>.from(widget.requirements)..remove(req);
                            widget.onRequirementsChanged(updated);
                          },
                        );
                      }).toList(),
                    ),
                  ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 24.h,
                  width: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white60 : Colors.grey[600]),
                  onPressed: () => _showRequirementPicker(context),
                ),
              ],
            ),
          ),
          onSubmitted: (_) => _addRequirement(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(label, isDark),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: _getInputDecoration(hint: hint, isDark: isDark),
        ),
      ],
    );
  }

  InputDecoration _getInputDecoration({
    required String hint,
    required bool isDark,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(), // Allows wrap to size properly
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.grey[400],
      ),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required String hint,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(label, isDark),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: value == null
                          ? (isDark ? Colors.white38 : Colors.grey[400])
                          : (isDark ? Colors.white : AppColors.textPrimary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showFormatPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Primary Format',
        options: ['PNG', 'PDF', 'JPG', 'PSD', 'AI', 'EPS', 'SVG', 'MP4', 'WAV', 'ZIP'],
      ),
    );
    if (result != null) {
      widget.onDeliveryFormatChanged(result);
    }
  }

  Future<void> _showCoverageAreaPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Coverage Areas',
        options: [
          '##HEADER##GLOBAL',
          'Online',
          'Global',
          '##HEADER##NATIONAL',
          'Nationwide',
          '##HEADER##REGIONAL',
          'West Africa',
          'Africa',
          '##HEADER##STATES',
          'Abia', 'Adamawa', 'Akwa Ibom', 'Anambra', 'Bauchi', 'Bayelsa', 'Benue', 'Borno',
          'Cross River', 'Delta', 'Ebonyi', 'Edo', 'Ekiti', 'Enugu', 'FCT', 'Gombe', 'Imo',
          'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Lagos', 'Nasarawa',
          'Niger', 'Ogun', 'Ondo', 'Osun', 'Oyo', 'Plateau', 'Rivers', 'Sokoto', 'Taraba',
          'Yobe', 'Zamfara'
        ],
      ),
    );
    if (result != null) {
      if (!widget.coverageAreas.contains(result)) {
        final updated = List<String>.from(widget.coverageAreas)..add(result);
        widget.onCoverageAreasChanged(updated);
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
          '##HEADER##CONTENT',
          'Ugc',
          'Content Creation',
          'Influencer',
          'Product Review',
          'Unboxing',
          'Lifestyle',
          '##HEADER##AUDIO',
          'Voice Over',
          'Jingle',
          'Podcast',
          'Audio Ad',
          '##HEADER##MARKETING',
          'Ads',
          'Campaign',
          'Promotion',
          'Brand Awareness',
          'Lead Generation',
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

  Future<void> _showFeaturePicker(BuildContext context) async {
    List<String> options = [];
    final type = widget.selectedType?.toLowerCase() ?? '';
    
    if (type.contains('design') || type.contains('graphics')) {
      options = ['##HEADER##DESIGN FEATURES', 'Source File', 'High Resolution', 'Vector File', '3D Mockup', 'Commercial Use'];
    } else if (type.contains('audio') || type.contains('voice') || type.contains('jingle') || type.contains('podcast')) {
      options = ['##HEADER##AUDIO FEATURES', 'HQ Audio', 'Background Music', 'Commercial Rights', 'Separated Tracks'];
    } else if (type.contains('video') || type.contains('ad') || type.contains('ugc')) {
      options = ['##HEADER##VIDEO FEATURES', '1080p Resolution', '4K Resolution', 'Background Music', 'Subtitles', 'Stock Footage'];
    } else if (type.contains('writing') || type.contains('content')) {
      options = ['##HEADER##WRITING FEATURES', 'SEO Optimized', 'Plagiarism Check', 'References Included', 'Commercial Use'];
    } else {
      options = ['##HEADER##STANDARD FEATURES', 'High Quality Delivery', 'Commercial Use', 'Revisions Included', 'Priority Support'];
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

  Future<void> _showRequirementPicker(BuildContext context) async {
    List<String> options = [];
    final type = widget.selectedType?.toLowerCase() ?? '';
    
    if (type.contains('design') || type.contains('graphics')) {
      options = ['##HEADER##DESIGN REQS', 'Brand Guidelines', 'Logo/Assets', 'Color Preferences', 'Target Audience Profile'];
    } else if (type.contains('audio') || type.contains('voice') || type.contains('jingle') || type.contains('podcast')) {
      options = ['##HEADER##AUDIO REQS', 'Script', 'Voice Reference', 'Pronunciation Guide', 'BGM Preferences'];
    } else if (type.contains('video') || type.contains('ad') || type.contains('ugc')) {
      options = ['##HEADER##VIDEO REQS', 'Script', 'Voiceover Details', 'Brand Logos', 'Text Overlays'];
    } else if (type.contains('writing') || type.contains('content')) {
      options = ['##HEADER##WRITING REQS', 'Topic Details', 'Keywords', 'Tone of Voice', 'Word Count Target'];
    } else {
      options = ['##HEADER##GENERAL REQS', 'Project Brief', 'Reference Examples', 'Target Audience Info', 'Timeline Constraints'];
    }

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet(
        title: 'Select Requirements',
        options: options,
      ),
    );
    if (result != null) {
      if (!widget.requirements.contains(result)) {
        final updated = List<String>.from(widget.requirements)..add(result);
        widget.onRequirementsChanged(updated);
      }
    }
  }
}
