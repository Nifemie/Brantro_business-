import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import 'service_project_details_form.dart';

class EditServiceDetailsSheet extends StatefulWidget {
  final String serviceName;
  final String? initialDescription;
  final List<String>? initialLinks;
  final List<Map<String, dynamic>>? initialFiles;
  final Function(Map<String, dynamic> projectDetails) onSave;

  const EditServiceDetailsSheet({
    super.key,
    required this.serviceName,
    this.initialDescription,
    this.initialLinks,
    this.initialFiles,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required String serviceName,
    String? initialDescription,
    List<String>? initialLinks,
    List<Map<String, dynamic>>? initialFiles,
    required Function(Map<String, dynamic> projectDetails) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditServiceDetailsSheet(
          serviceName: serviceName,
          initialDescription: initialDescription,
          initialLinks: initialLinks,
          initialFiles: initialFiles,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<EditServiceDetailsSheet> createState() => _EditServiceDetailsSheetState();
}

class _EditServiceDetailsSheetState extends State<EditServiceDetailsSheet> {
  final _formKey = GlobalKey<FormState>();
  late ServiceProjectDetailsData _projectData;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _projectData = ServiceProjectDetailsData(
      initialDescription: widget.initialDescription,
      initialLinks: widget.initialLinks,
      initialFiles: widget.initialFiles,
    );
  }

  @override
  void dispose() {
    _projectData.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_projectData.toJson());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Title and close button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Project Details', style: AppTexts.h3()),
                          SizedBox(height: 4.h),
                          Text(
                            widget.serviceName,
                            style: AppTexts.bodySmall(color: AppColors.grey600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.grey600),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: ServiceProjectDetailsForm(
                  data: _projectData,
                  showHeader: false,
                  onDataChanged: () {
                    setState(() {
                      _hasChanges = true;
                    });
                  },
                ),
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.grey700,
                        side: BorderSide(color: AppColors.grey300),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
