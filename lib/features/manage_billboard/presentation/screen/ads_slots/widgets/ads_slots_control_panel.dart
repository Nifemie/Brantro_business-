import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ads_slots_actions_row.dart';

class AdsSlotsControlPanel extends StatefulWidget {
  final bool isDark;

  const AdsSlotsControlPanel({super.key, required this.isDark});

  @override
  State<AdsSlotsControlPanel> createState() => _AdsSlotsControlPanelState();
}

class _AdsSlotsControlPanelState extends State<AdsSlotsControlPanel> {
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.07);

    final bgColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.02);

    final subtleTextColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.45)
        : Colors.black.withValues(alpha: 0.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Main glassmorphic panel ──
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Title ──
                  Text(
                    'All Ads Slots',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: widget.isDark
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildSearchBar(borderColor, subtleTextColor),
                  SizedBox(height: 14.h),
                  _buildFilterRow(subtleTextColor),
                  SizedBox(height: 14.h),
                  AdsSlotsActionsRow(
                    isGridView: _isGridView,
                    onViewChanged: (val) => setState(() => _isGridView = val),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // ── Filter label below the panel ──
        Row(
          children: [
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: widget.isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Location Id: 9',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: widget.isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Search bar with icon
  Widget _buildSearchBar(Color borderColor, Color hintColor) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search slots...',
                hintStyle: TextStyle(fontSize: 14.sp, color: hintColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: borderColor, width: 1)),
            ),
            child: Icon(Icons.search, color: hintColor, size: 22.sp),
          ),
        ],
      ),
    );
  }

  /// Platform & Partner Type filter chips
  Widget _buildFilterRow(Color hintColor) {
    return Row(
      children: [
        Expanded(child: _buildFilterChip(label: 'Platform')),
        SizedBox(width: 12.w),
        Expanded(child: _buildFilterChip(label: 'Partner Type')),
      ],
    );
  }

  /// Individual filter chip
  Widget _buildFilterChip({required String label}) {
    final chipColor = widget.isDark ? Colors.grey[500] : Colors.grey[400];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_alt_outlined, size: 18.sp, color: chipColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}
