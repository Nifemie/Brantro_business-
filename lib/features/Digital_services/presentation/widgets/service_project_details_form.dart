import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

// Class to hold project details data
class ServiceProjectDetailsData {
  final TextEditingController descriptionController;
  final List<TextEditingController> referenceLinkControllers;
  final List<Map<String, dynamic>> attachedFiles;

  ServiceProjectDetailsData({
    String? initialDescription,
    List<String>? initialLinks,
    List<Map<String, dynamic>>? initialFiles,
  })  : descriptionController = TextEditingController(text: initialDescription ?? ''),
        referenceLinkControllers = (initialLinks ?? [])
            .map((link) => TextEditingController(text: link))
            .toList(),
        attachedFiles = List.from(initialFiles ?? []);

  void addReferenceLink() {
    referenceLinkControllers.add(TextEditingController());
  }

  void removeReferenceLink(int index) {
    referenceLinkControllers[index].dispose();
    referenceLinkControllers.removeAt(index);
  }

  void dispose() {
    descriptionController.dispose();
    for (var controller in referenceLinkControllers) {
      controller.dispose();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'description': descriptionController.text.trim(),
      'referenceLinks': referenceLinkControllers
          .map((c) => c.text.trim())
          .where((link) => link.isNotEmpty)
          .toList(),
      'attachedFiles': attachedFiles,
    };
  }

  bool get hasRequiredData {
    return descriptionController.text.trim().isNotEmpty;
  }
}

class ServiceProjectDetailsForm extends StatefulWidget {
  final ServiceProjectDetailsData data;
  final VoidCallback? onDataChanged;
  final bool showHeader;
  final String? serviceName;

  const ServiceProjectDetailsForm({
    super.key,
    required this.data,
    this.onDataChanged,
    this.showHeader = true,
    this.serviceName,
  });

  @override
  State<ServiceProjectDetailsForm> createState() => _ServiceProjectDetailsFormState();
}

class _ServiceProjectDetailsFormState extends State<ServiceProjectDetailsForm> {
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            if (file.size <= 10 * 1024 * 1024) {
              widget.data.attachedFiles.add({
                'id': DateTime.now().millisecondsSinceEpoch.toString() +
                    file.name.hashCode.toString(),
                'name': file.name,
                'mimeType': _getMimeType(file.extension ?? ''),
                'size': file.size,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${file.name} is too large (max 10MB)')),
              );
            }
          }
        });
        widget.onDataChanged?.call();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHeader) ...[
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project Details', style: AppTexts.h4()),
                    if (widget.serviceName != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        widget.serviceName!,
                        style: AppTexts.bodySmall(color: AppColors.grey600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],

        // Description Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Description',
                    style: AppTexts.bodyMedium(color: AppColors.grey900)),
                SizedBox(width: 4.w),
                Text('*',
                    style: TextStyle(color: Colors.red, fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: widget.data.descriptionController,
              maxLines: 5,
              style: AppTexts.bodyMedium(),
              decoration: InputDecoration(
                hintText:
                    'Describe your project requirements, goals, and expectations...',
                hintStyle: AppTexts.bodySmall(color: AppColors.grey500),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: EdgeInsets.all(16.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.grey300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              onChanged: (_) => widget.onDataChanged?.call(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please describe your project';
                }
                return null;
              },
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // Reference Links Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reference Links',
                    style: AppTexts.bodyMedium(color: AppColors.grey900)),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      widget.data.addReferenceLink();
                    });
                    widget.onDataChanged?.call();
                  },
                  icon: Icon(Icons.add_circle_outline,
                      size: 18.sp, color: AppColors.primaryColor),
                  label: Text('Add Link',
                      style:
                          AppTexts.labelSmall(color: AppColors.primaryColor)),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (widget.data.referenceLinkControllers.isEmpty)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link_off,
                        color: AppColors.grey400, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text(
                      'No reference links added yet',
                      style: AppTexts.bodySmall(color: AppColors.grey500),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(widget.data.referenceLinkControllers.length,
                  (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller:
                              widget.data.referenceLinkControllers[index],
                          style: AppTexts.bodySmall(),
                          decoration: InputDecoration(
                            hintText: 'https://example.com',
                            hintStyle:
                                AppTexts.bodySmall(color: AppColors.grey400),
                            prefixIcon: Icon(Icons.link,
                                size: 18.sp, color: AppColors.primaryColor),
                            filled: true,
                            fillColor: AppColors.grey50,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 14.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.grey300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.grey300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                  color: AppColors.primaryColor, width: 2),
                            ),
                          ),
                          onChanged: (_) => widget.onDataChanged?.call(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: Colors.red, size: 20.sp),
                          onPressed: () {
                            setState(() {
                              widget.data.removeReferenceLink(index);
                            });
                            widget.onDataChanged?.call();
                          },
                          padding: EdgeInsets.all(8.w),
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),

        SizedBox(height: 24.h),

        // Attach Files Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attach Files',
                style: AppTexts.bodyMedium(color: AppColors.grey900)),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _pickFiles,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.primaryColor,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Click to upload files',
                      style:
                          AppTexts.bodyMedium(color: AppColors.primaryColor),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'PDF, DOC, DOCX, JPG, PNG (Max 10MB each)',
                      style: AppTexts.labelSmall(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
            ),

            // Show attached files
            if (widget.data.attachedFiles.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_file,
                            size: 16.sp, color: AppColors.grey700),
                        SizedBox(width: 6.w),
                        Text(
                          '${widget.data.attachedFiles.length} file(s) attached',
                          style: AppTexts.labelSmall(color: AppColors.grey700),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ...List.generate(widget.data.attachedFiles.length, (index) {
                      final file = widget.data.attachedFiles[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 6.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.insert_drive_file,
                                color: AppColors.primaryColor, size: 18.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                file['name'] ?? '',
                                style: AppTexts.bodySmall(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.data.attachedFiles.removeAt(index);
                                });
                                widget.onDataChanged?.call();
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(Icons.close,
                                    color: Colors.red, size: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
