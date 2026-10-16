import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/order_model.dart';

class OrderRequirementsCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderRequirementsCard({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final requirements = order.requirementsProvided;
    final hasRequirements = requirements != null && requirements.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
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
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Service Requirements',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (!hasRequirements)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : const Color(0xFFF3F6F9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Requirements have not been provided yet. Please reach out to the advertiser if needed.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            if (requirements['description'] != null && requirements['description'].toString().isNotEmpty) ...[
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                requirements['description'].toString(),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),
            ],
            if (requirements['files'] != null && (requirements['files'] as List).isNotEmpty) ...[
              Text(
                'Attached Files',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              ...((requirements['files'] as List).map((file) {
                return _buildFileItem(context, file as Map<String, dynamic>);
              }).toList()),
            ],
            if (requirements['links'] != null && (requirements['links'] as List).isNotEmpty) ...[
              Text(
                'Reference Links',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              ...((requirements['links'] as List).map((link) {
                return _buildLinkItem(context, link.toString());
              }).toList()),
              SizedBox(height: 12.h),
            ],
            if (requirements['submittedAt'] != null) ...[
              SizedBox(height: 16.h),
              Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Submitted: ${DateFormat('MMM d, yyyy • h:mm a').format(DateTime.tryParse(requirements['submittedAt'].toString()) ?? DateTime.now())}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ]
          ]
        ],
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, Map<String, dynamic> file) {
    final fileName = file['name']?.toString() ?? 'Attachment';
    final mimeType = file['mimeType']?.toString() ?? '';
    final size = file['size'] is num ? ((file['size'] as num) / 1024).toStringAsFixed(1) : '0';
    final rawUrl = file['id']?.toString() ?? file['url']?.toString() ?? '';
    
    final fileUrl = rawUrl.startsWith('http') ? rawUrl : '${ApiClient.fileBaseUrl}/$rawUrl';
    
    IconData fileIcon = Icons.insert_drive_file_outlined;
    if (mimeType.startsWith('image/') || fileName.toLowerCase().endsWith('.jpg') || fileName.toLowerCase().endsWith('.png') || fileName.toLowerCase().endsWith('.jpeg')) {
      fileIcon = Icons.image_outlined;
    } else if (mimeType == 'application/pdf' || fileName.toLowerCase().endsWith('.pdf')) {
      fileIcon = Icons.picture_as_pdf_outlined;
    } else if (mimeType.startsWith('video/')) {
      fileIcon = Icons.video_file_outlined;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchUrl(context, fileUrl),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : const Color(0xFFF3F6F9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: fileIcon == Icons.image_outlined && rawUrl.isNotEmpty
                      ? Image.network(
                          fileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[500],
                            size: 24.sp,
                          ),
                        )
                      : Icon(
                          fileIcon,
                          color: AppColors.primaryColor,
                          size: 24.sp,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$size KB',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: isDark ? Colors.grey[400] : Colors.grey[400],
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String url) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () => _launchUrl(context, url),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.link_rounded,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  url,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    if (urlString.isEmpty) return;
    
    final uri = Uri.parse(urlString);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
