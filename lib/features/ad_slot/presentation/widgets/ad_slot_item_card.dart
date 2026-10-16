import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/html_helper.dart';
import '../../data/models/ad_slot_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ad_slot_status_badge.dart';
import 'ad_slot_detail_box.dart';
import 'ad_slot_options_menu.dart';
import 'ad_slot_price_container.dart';

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

    final hasSocialData = slot.platforms != null && slot.platforms!.isNotEmpty;

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
          // Top Row: Platform Icon + Platform Name & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (hasSocialData) ...[
                      // Render Instagram SVG
                      if (slot.platforms!.contains('instagram')) ...[
                        SvgPicture.string(
                          '<svg viewBox="0 0 24 24" fill="none" stroke="#E1306C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line></svg>',
                          width: 24.w,
                          height: 24.h,
                        ),
                        SizedBox(width: 8.w),
                      ] else if (slot.platforms!.contains('tiktok')) ...[
                        SvgPicture.string(
                          '<svg viewBox="0 0 24 24" fill="none" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24"><path d="M9 12a4 4 0 1 0 4 4V4a5 5 0 0 0 5 5"></path></svg>',
                          width: 24.w,
                          height: 24.h,
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Expanded(
                        child: Text(
                          slot.platforms!.map((p) => p[0].toUpperCase() + p.substring(1)).join(', '),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(6.w),
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
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          slot.parentType.isNotEmpty 
                              ? slot.parentType[0].toUpperCase() + slot.parentType.substring(1)
                              : 'General',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AdSlotStatusBadge(status: slot.status),
            ],
          ),

          SizedBox(height: 12.h),

          // Title: "Instagram Story Promotion (50K+ Audience)"
          Text(
            slot.title ?? slot.slotNumber,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A2B4B),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),

          // Deliverables (ContentTypes) / Description & Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  slot.contentTypes != null && slot.contentTypes!.isNotEmpty
                      ? slot.contentTypes!.map((c) => c.toString()).join(', ')
                      : HtmlHelper.stripHtml(slot.description ?? (slot.bookedBy != null ? 'Booked by: ${slot.bookedBy}' : 'Not booked')),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (slot.badge != null || slot.partnerType != null) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    (slot.badge ?? slot.partnerType!).replaceAll('_', ' ').split(' ').map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1).toLowerCase() : '').join(' '),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 16.h),

          // Large Price & Duration Container
          AdSlotPriceContainer(
            price: slot.price,
            duration: slot.duration,
          ),

          SizedBox(height: 16.h),

          // Three Detail Boxes: Revisions, Audience, Orders
          Row(
            children: [
              Expanded(
                child: AdSlotDetailBox(label: 'Revisions', value: '${slot.maxRevisions ?? 'N/A'}'),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AdSlotDetailBox(label: 'Audience', value: slot.audience ?? 'N/A'),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AdSlotDetailBox(label: 'Orders', value: '${slot.ordersCount ?? 0}'),
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
              // Menu Button (three dots) with custom orange styling
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBE3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFFFC5B0),
                    width: 1.5,
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: const Color(0xFFFF6B35),
                    size: 24.sp,
                  ),
                  color: theme.cardTheme.color ?? (isDark ? Colors.grey[850] : Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  offset: Offset(0, 50.h),
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'update') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'update',
                      child: Row(
                        children: [
                          Icon(Icons.edit_square, size: 18.sp, color: isDark ? Colors.white70 : Colors.grey[800]),
                          SizedBox(width: 12.w),
                          Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? Colors.white : Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18.sp, color: Colors.red),
                          SizedBox(width: 12.w),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              // View Orders Button
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/ad-campaigns', extra: {
                            'parentId': slot.id.toString(), // This is the adSlotId
                            'parentType': slot.parentType,
                            'parentName': slot.slotNumber,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003D82),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'View Orders',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6.h,
                      right: -6.w,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20.w,
                          minHeight: 20.h,
                        ),
                        child: Text(
                          '${slot.ordersCount ?? 0}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
