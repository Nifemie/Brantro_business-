import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/ad_slot_model.dart';

class AdSlotItemCard extends StatelessWidget {
  final AdSlotModel slot;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdSlotItemCard({
    super.key,
    required this.slot,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? (isDark ? Colors.grey[850] : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Link Icon + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.link,
                  size: 20.sp,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              _buildStatusBadge(isDark),
            ],
          ),

          SizedBox(height: 16.h),

          // Slot Name (Title)
          Text(
            slot.slotNumber,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A2B4B),
            ),
          ),

          SizedBox(height: 12.h),

          // Booked By Info Row
          Text(
            slot.bookedBy != null ? 'Booked by: ${slot.bookedBy}' : 'Not booked',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),

          SizedBox(height: 20.h),

          // Price and Duration Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₦${_formatPrice(slot.price)}',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF6B35),
                ),
              ),
              Text(
                '${slot.duration}days',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Max Revisions and Audience Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Max Revisions: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${slot.maxRevisions ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Audience: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    slot.audience ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Date Range (if booked)
          if (slot.startDate != null && slot.endDate != null) ...[
            SizedBox(height: 20.h),
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? Colors.grey[800] : Colors.grey[200],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                SizedBox(width: 8.w),
                Text(
                  '${DateFormat('MMM dd, yyyy').format(slot.startDate!)} - ${DateFormat('MMM dd, yyyy').format(slot.endDate!)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 20.h),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[200],
          ),
          SizedBox(height: 16.h),

          // Action Buttons Row
          Row(
            children: [
              // Menu Button (three dots)
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : const Color(0xFFFFE5DC),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : const Color(0xFFFFD4C4),
                  ),
                ),
                child: IconButton(
                  onPressed: () => _showOptionsMenu(context),
                  icon: Icon(
                    Icons.more_horiz,
                    color: isDark ? Colors.white70 : const Color(0xFFFF6B35),
                    size: 24.sp,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),

              SizedBox(width: 12.w),

              // View Orders Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/ad-campaigns', extra: {
                      'parentId': slot.parentId,
                      'parentType': slot.parentType,
                      'parentName': slot.slotNumber,
                    });
                  },
                  icon: Icon(Icons.shopping_bag_outlined, size: 18.sp),
                  label: Text(
                    'View Orders',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : const Color(0xFF1A2B4B),
                    side: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Update Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined, size: 18.sp),
                  label: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003D82),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    Color badgeColor;
    String statusText;

    switch (slot.status.toLowerCase()) {
      case 'available':
        badgeColor = const Color(0xFF00C853);
        statusText = 'Available';
        break;
      case 'booked':
        badgeColor = const Color(0xFFFF9800);
        statusText = 'Booked';
        break;
      case 'occupied':
        badgeColor = Colors.red;
        statusText = 'Occupied';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = slot.status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      title: Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to slot details
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.share_outlined,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      title: Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Share slot
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
