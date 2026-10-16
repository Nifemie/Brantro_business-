import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdPlacementCard extends StatelessWidget {
  final String placementId;
  final String description;
  final String advertiserName;
  final String advertiserEmail;
  final String platforms;
  final String contentTypes;
  final double amount;
  final String date;
  final String status;
  final bool hasApprovedProof;
  final VoidCallback? onMenuTap;
  final VoidCallback? onAcceptTap;
  final VoidCallback? onRejectTap;
  final VoidCallback? onViewTap;
  final VoidCallback? onUploadProof;
  final VoidCallback? onMarkInProgress;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onCancelTap;

  const AdPlacementCard({
    super.key,
    required this.placementId,
    required this.description,
    required this.advertiserName,
    required this.advertiserEmail,
    required this.platforms,
    required this.contentTypes,
    required this.amount,
    required this.date,
    required this.status,
    this.hasApprovedProof = false,
    this.onMenuTap,
    this.onAcceptTap,
    this.onRejectTap,
    this.onViewTap,
    this.onUploadProof,
    this.onMarkInProgress,
    this.onMarkCompleted,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onViewTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
        color: theme.cardTheme.color ?? (isDark ? Colors.grey[900] : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Banner
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : const Color(0xFFF3F6F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.shopping_bag_outlined, // Tote bag equivalent
                    size: 48.sp,
                    color: isDark ? Colors.white54 : const Color(0xFF7A8D9C),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: _buildStatusBadge(status, isDark),
                ),
              ],
            ),
          ),

          // Content Area
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placement #$placementId',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Advertiser: $advertiserName',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Email: $advertiserEmail',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Platforms: $platforms',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Content Types: $contentTypes',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Amount and Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₦${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E3A5F),
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white54 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Buttons Row
                _buildActionButtons(status, isDark),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color badgeColor;
    String badgeText;

    switch (status.trim().toLowerCase()) {
      case 'pending':
      case 'requested':
        badgeColor = const Color(0xFFFF7A45); // Matching screenshot orange
        badgeText = 'Requested';
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        badgeText = 'Cancelled';
        break;
      case 'approved':
      case 'accepted':
        badgeColor = Colors.green;
        badgeText = 'Accepted';
        break;
      case 'completed':
        badgeColor = Colors.blue;
        badgeText = 'Completed';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = status.isNotEmpty 
            ? status[0].toUpperCase() + status.substring(1).toLowerCase() 
            : 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status, bool isDark) {
    final statusLower = status.trim().toLowerCase();
    final isInProgress = statusLower == 'inprogress' || statusLower == 'in_progress';
    
    // Always show the row with the menu button. If requested/pending, show Accept/Reject.
    // If not, maybe just show View Details or disable the Accept/Reject? 
    // The screenshot implies this is the layout for Requested.
    
    if (statusLower == 'requested' || statusLower == 'pending') {
      return Row(
        children: [
          // Menu button
          _buildPopupMenu(isDark, statusLower, isInProgress),
          SizedBox(width: 12.w),
          
          // Accept Button
          Expanded(
            child: ElevatedButton(
              onPressed: onAcceptTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E), // Green
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          
          // Reject Button
          Expanded(
            child: ElevatedButton(
              onPressed: onRejectTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444), // Red
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Reject',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    final isAccepted = statusLower == 'accepted' || statusLower == 'approved';
    
    if (isAccepted || isInProgress) {
      return Row(
        children: [
          // Menu button
          _buildPopupMenu(isDark, statusLower, isInProgress),
          SizedBox(width: 12.w),
          
          // Action Button
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: hasApprovedProof 
                  ? onMarkCompleted 
                  : (isAccepted ? onMarkInProgress : onUploadProof),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasApprovedProof 
                    ? Colors.green 
                    : (isAccepted ? const Color(0xFFFF7A45) : Colors.teal),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasApprovedProof 
                        ? Icons.check_circle_outline 
                        : (isAccepted ? Icons.play_circle_outline : Icons.file_upload_outlined), 
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    hasApprovedProof 
                        ? 'Complete' 
                        : (isAccepted ? 'Start Work' : 'Upload Proof'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          
          // View Details Button
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: onViewTap,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_outlined, 
                    size: 16.sp,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white70 : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    // For other statuses, show a generic View Details button for the placement
    return Row(
      children: [
        _buildPopupMenu(isDark, statusLower, isInProgress),
        SizedBox(width: 12.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onViewTap, // Using onViewTap here too
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'View Details',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(bool isDark, String statusLower, bool isInProgress) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'mark_in_progress') {
          onMarkInProgress?.call();
        } else if (value == 'mark_completed') {
          onMarkCompleted?.call();
        } else if (value == 'cancel') {
          onCancelTap?.call();
        } else if (value == 'upload_proof') {
          onUploadProof?.call();
        } else if (value == 'view_details') {
          onViewTap?.call();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: isDark ? Colors.grey[800] : Colors.white,
      offset: const Offset(0, 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: statusLower == 'accepted' || statusLower == 'approved' || statusLower == 'requested' || statusLower == 'pending'
                 ? (isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFF0E6))
                 : (isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: statusLower == 'accepted' || statusLower == 'approved' || statusLower == 'requested' || statusLower == 'pending'
                   ? (isDark ? Colors.orange.withOpacity(0.3) : const Color(0xFFFFD1B3))
                   : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        child: Icon(
          Icons.more_horiz,
          color: statusLower == 'accepted' || statusLower == 'approved' || statusLower == 'requested' || statusLower == 'pending'
                 ? const Color(0xFFFF7A45)
                 : (isDark ? Colors.white70 : Colors.grey[700]),
          size: 20.sp,
        ),
      ),
      itemBuilder: (context) {
        final isAccepted = statusLower == 'accepted' || statusLower == 'approved';
        return [
          if (isAccepted && !hasApprovedProof) ...[
            PopupMenuItem(
              value: 'mark_in_progress',
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline, color: Colors.blue, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('Mark In Progress', style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
                ],
              ),
            ),
            const PopupMenuDivider(),
          ],
          if (isInProgress || (isAccepted && hasApprovedProof)) ...[
            if (hasApprovedProof) ...[
              PopupMenuItem(
                value: 'mark_completed',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('Mark as Completed', style: TextStyle(color: Colors.green, fontSize: 14.sp)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
            ],
            if (!hasApprovedProof) ...[
              PopupMenuItem(
                value: 'upload_proof',
                child: Row(
                  children: [
                    Icon(Icons.file_upload_outlined, color: Colors.teal, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('Upload Proof', style: TextStyle(color: Colors.teal, fontSize: 14.sp)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
            ],
          ],
          if (statusLower == 'pending' || statusLower == 'requested' || isAccepted || isInProgress) ...[
          PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                Icon(Icons.cancel_outlined, color: Colors.red, size: 18.sp),
                SizedBox(width: 8.w),
                Text('Cancel Placement', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
              ],
            ),
          ),
          const PopupMenuDivider(),
        ],

        PopupMenuItem(
          value: 'view_details',
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, color: isDark ? Colors.white70 : Colors.grey[800], size: 18.sp),
              SizedBox(width: 8.w),
              Text('View Details', style: TextStyle(color: isDark ? Colors.white : Colors.grey[800], fontSize: 14.sp)),
            ],
          ),
        ),
        ];
      },
    );
  }
}
