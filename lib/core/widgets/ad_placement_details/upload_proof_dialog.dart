import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/ad_slot/logic/ad_placement_provider.dart';
import '../../../core/data/repositories/file_repository.dart';

class UploadProofDialog extends ConsumerStatefulWidget {
  final int placementId;
  final String campaignId;

  const UploadProofDialog({
    super.key,
    required this.placementId,
    required this.campaignId,
  });

  @override
  ConsumerState<UploadProofDialog> createState() => _UploadProofDialogState();
}

class _UploadProofDialogState extends ConsumerState<UploadProofDialog> {
  String? _selectedProofType;
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Container(
        width: 500.w, // Dialog width based on screenshot
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Proof for Placement #${widget.placementId}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: isDark ? Colors.white54 : Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[800] : Colors.grey[200],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Proof File Section
                  _buildLabel('Proof File', isDark),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[850]
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpg', 'jpeg'],
                            );

                        if (result != null) {
                          setState(() {
                            _selectedFile = result.files.first;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF1E3A5F),
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedFile != null
                                      ? 'File selected'
                                      : 'Click to upload',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedFile != null
                                        ? Colors.green
                                        : const Color(0xFFFF7A45),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _selectedFile != null
                                      ? _selectedFile!.name
                                      : 'PNG, JPG, JPEG (1600x1200 recommended)',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isDark
                                        ? Colors.grey[500]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload screenshot or image proof of the ad placement',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Proof Type Section
                  _buildLabel('Proof Type', isDark),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[850]
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProofType,
                        isExpanded: true,
                        hint: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Select proof type',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        icon: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                        ),
                        items:
                            [
                                  'Screenshot',
                                  'Video Recording',
                                  'Link',
                                  'Analytics Report',
                                ]
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: Text(
                                        type,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.grey[800],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedProofType = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : const Color(0xFFF3F4F6),
                      foregroundColor: isDark ? Colors.white : Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () async {
                            if (_selectedFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a proof file'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (_selectedProofType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a proof type'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() => _isUploading = true);
                            try {
                              // First, upload the file to get the URL
                              final fileUrl = await ref
                                  .read(fileRepositoryProvider)
                                  .uploadFile(
                                    _selectedFile!.path!,
                                    prefix: 'ad-proof',
                                  );

                              // Then, send the proof data
                              final payload = {
                                'placementId': widget.placementId,
                                'proofUrl': fileUrl,
                                'proofType': _selectedProofType,
                              };

                              await ref
                                  .read(
                                    adPlacementProvider(
                                      widget.campaignId,
                                    ).notifier,
                                  )
                                  .uploadProof(widget.placementId, payload);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Proof uploaded successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            } catch (e, stack) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isUploading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A45), // Orange
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                    ),
                    child: _isUploading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Upload Proof',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.grey[900],
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '*',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF7A45), // Red/Orange asterisk
          ),
        ),
      ],
    );
  }
}
