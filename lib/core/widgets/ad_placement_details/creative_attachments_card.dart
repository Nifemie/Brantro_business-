import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../features/ad_slot/data/models/ad_placement_model.dart';
import 'ad_placement_details_shared.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/network/api_client.dart';

class CreativeAttachmentsCard extends StatelessWidget {
  final AdPlacementModel placement;
  final bool isDark;

  const CreativeAttachmentsCard({
    super.key,
    required this.placement,
    required this.isDark,
  });

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open link: $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final attachments = placement.rawJson['attachments'] as List? ?? [];

    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Creative Attachments',
      titleIcon: Icons.attachment_outlined,
      child: attachments.isEmpty
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 48.h),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.attachment_outlined,
                      color: const Color(0xFFFF7A45),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Attachments',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'The advertiser did not include any attachments.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.white54 : Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (placement.rawJson['advertiser'] != null &&
                      placement.rawJson['advertiser']['phoneNumber'] != null &&
                      placement.rawJson['advertiser']['phoneNumber'].toString().isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'Reach out to advertiser: ${placement.rawJson['advertiser']['phoneNumber']}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.blue[300] : const Color(0xFF003D82),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            )
          : Column(
              children: attachments.map((att) {
                final attachment = att as Map<String, dynamic>;
                final fileName = attachment['name'] ?? 'Unknown file';
                final rawFileUrl = attachment['fileUrl'] ?? attachment['url'] ?? attachment['file'] ?? attachment['id']?.toString() ?? '';
                final fileUrl = rawFileUrl.isEmpty || rawFileUrl.startsWith('http') 
                    ? rawFileUrl 
                    : '${ApiClient.fileBaseUrl}/$rawFileUrl';
                final uploadedAtStr = attachment['createdAt'] ?? '';

                String dateStr = '-';
                if (uploadedAtStr.isNotEmpty) {
                  try {
                    dateStr = DateFormat(
                      'M/d/yyyy, h:mm a',
                    ).format(DateTime.parse(uploadedAtStr));
                  } catch (e) {}
                }

                // Determine icon based on file extension
                IconData fileIcon = Icons.insert_drive_file_outlined;
                if (fileName.toLowerCase().endsWith('.png') ||
                    fileName.toLowerCase().endsWith('.jpg') ||
                    fileName.toLowerCase().endsWith('.jpeg')) {
                  fileIcon = Icons.image_outlined;
                } else if (fileName.toLowerCase().endsWith('.pdf')) {
                  fileIcon = Icons.picture_as_pdf_outlined;
                } else if (fileName.toLowerCase().endsWith('.mp4') ||
                    fileName.toLowerCase().endsWith('.mov')) {
                  fileIcon = Icons.video_file_outlined;
                }

                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: isDark ? [] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row with image/icon and details
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail or Icon
                            Container(
                              height: 56.r,
                              width: 56.r,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : const Color(0xFFF3F6F9),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: fileIcon == Icons.image_outlined && fileUrl.isNotEmpty
                                  ? Image.network(
                                      fileUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.grey[500],
                                      ),
                                    )
                                  : Icon(
                                      fileIcon,
                                      color: const Color(0xFF003D82),
                                      size: 28.sp,
                                    ),
                            ),
                            SizedBox(width: 16.w),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fileName,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.grey[900],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Size: ${(attachment['size'] ?? 0) / 1000} KB',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[100]),
                      // Bottom Action Row
                      if (fileUrl.isNotEmpty)
                        InkWell(
                          onTap: () => _launchUrl(context, fileUrl),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.r),
                                bottomRight: Radius.circular(16.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  size: 16.sp,
                                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF003D82),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'View Attachment',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF003D82),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
