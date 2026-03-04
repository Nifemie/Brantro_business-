import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillboardFilterPanel extends StatefulWidget {
  final bool isDark;

  const BillboardFilterPanel({super.key, required this.isDark});

  @override
  State<BillboardFilterPanel> createState() => _BillboardFilterPanelState();
}

class _BillboardFilterPanelState extends State<BillboardFilterPanel> {
  String? _selectedCategory;
  String? _selectedCost;
  String? _selectedRating;

  // ── Category options ──
  static const _categories = [
    'All',
    'Billboard',
    'Wall Location',
    'Digital Screen',
    'Canva Templates',
    'Radio & TV Creatives',
    'Brand Kits',
    'Flyers & Posters',
    'Media Proposals',
    'Pitch Decks',
    'Motion Graphics',
  ];

  // ── Cost options ──
  static const _costs = ['Free', 'Paid', 'Sold'];

  // ── Rating options ──
  static const _ratings = [
    '1 ⭐ & Above',
    '2 ⭐ & Above',
    '3 ⭐ & Above',
    '4 ⭐ & Above',
  ];

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.07);

    final bgColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.02);

    return ClipRRect(
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
              // ── Categories section ──
              _buildSectionHeader('Categories'),
              SizedBox(height: 12.h),
              ..._categories.map(
                (c) => _buildRadioOption(
                  label: c,
                  value: c,
                  groupValue: _selectedCategory,
                  onChanged: (val) => setState(() => _selectedCategory = val),
                ),
              ),

              SizedBox(height: 24.h),

              // ── Cost section ──
              _buildSectionHeader('Cost'),
              SizedBox(height: 12.h),
              ..._costs.map(
                (c) => _buildRadioOption(
                  label: c,
                  value: c,
                  groupValue: _selectedCost,
                  onChanged: (val) => setState(() => _selectedCost = val),
                ),
              ),

              SizedBox(height: 24.h),

              // ── Rating section ──
              _buildSectionHeader('Rating'),
              SizedBox(height: 12.h),
              ..._ratings.map(
                (r) => _buildRadioOption(
                  label: r,
                  value: r,
                  groupValue: _selectedRating,
                  onChanged: (val) => setState(() => _selectedRating = val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Glassmorphic section header pill
  Widget _buildSectionHeader(String title) {
    final headerBg = widget.isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.05);
    final headerBorder = widget.isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: headerBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: headerBorder, width: 1),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.7)
              : Colors.black.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  /// Single radio option row
  Widget _buildRadioOption({
    required String label,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = groupValue == value;
    final textColor = widget.isDark
        ? Colors.white.withValues(alpha: 0.8)
        : Colors.black.withValues(alpha: 0.75);

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Row(
          children: [
            // Outlined circle radio
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00388B)
                      : (widget.isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.25)),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00388B),
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
