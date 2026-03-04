import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdsSlotsActionsRow extends StatelessWidget {
  final bool isGridView;
  final ValueChanged<bool> onViewChanged;

  const AdsSlotsActionsRow({
    super.key,
    required this.isGridView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // List / Grid toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggle('List', !isGridView, () => onViewChanged(false)),
              _buildToggle('Grid', isGridView, () => onViewChanged(true)),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // + Create Slot button
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to create slot screen
          },
          icon: Icon(Icons.add, size: 18.sp),
          label: Text(
            'Create Slot',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003D82),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF003D82) : Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
