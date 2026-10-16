import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import 'block_dates_modal_sheet.dart';

class LocationAvailabilityCalendarCard extends StatefulWidget {
  final dynamic locationId;
  final List<dynamic>? blockedDates;
  final bool isDark;
  final VoidCallback? onDatesUpdated;

  const LocationAvailabilityCalendarCard({
    super.key,
    required this.locationId,
    this.blockedDates,
    required this.isDark,
    this.onDatesUpdated,
  });

  @override
  State<LocationAvailabilityCalendarCard> createState() =>
      _LocationAvailabilityCalendarCardState();
}

class _LocationAvailabilityCalendarCardState
    extends State<LocationAvailabilityCalendarCard> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  List<Map<String, dynamic>> _parseBlockedWindows() {
    if (widget.blockedDates == null) return [];
    final List<Map<String, dynamic>> list = [];
    for (final item in widget.blockedDates!) {
      if (item is Map) {
        final startStr = item['startDate']?.toString();
        final endStr = item['endDate']?.toString();
        if (startStr != null && endStr != null) {
          final start = DateTime.tryParse(startStr);
          final end = DateTime.tryParse(endStr);
          if (start != null && end != null) {
            list.add({
              'start': DateTime(start.year, start.month, start.day),
              'end': DateTime(end.year, end.month, end.day, 23, 59, 59),
              'reason': item['reason']?.toString() ?? 'Maintenance / Reserved',
              'type': item['type']?.toString() ?? 'MAINTENANCE',
            });
          }
        }
      }
    }
    return list;
  }

  bool _isDateBlocked(DateTime date, List<Map<String, dynamic>> windows) {
    final check = DateTime(date.year, date.month, date.day);
    for (final w in windows) {
      final start = w['start'] as DateTime;
      final end = w['end'] as DateTime;
      if (!check.isBefore(start) && !check.isAfter(end)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final blockedWindows = _parseBlockedWindows();
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = _currentMonth.weekday % 7;

    return Container(
      width: double.infinity,
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
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.calendar_month_rounded, color: AppColors.primaryColor, size: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Availability & Calendar',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Maintenance & blocked dates',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton.icon(
                onPressed: () => BlockDatesModalSheet.show(
                  context: context,
                  locationId: widget.locationId,
                  isDark: isDark,
                  onDatesUpdated: widget.onDatesUpdated,
                ),
                icon: Icon(Icons.block_rounded, size: 14.sp),
                label: Text('Block', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF59E0B),
                  side: const BorderSide(color: Color(0xFFF59E0B)),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Month Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                      });
                    },
                  ),
                  SizedBox(width: 12.w),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Weekdays Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 8.h),

          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox.shrink();
              final dayNumber = index - firstWeekday + 1;
              final dayDate = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isBlocked = _isDateBlocked(dayDate, blockedWindows);
              final isToday = DateUtils.isSameDay(dayDate, DateTime.now());

              return Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isBlocked
                      ? const Color(0xFFF59E0B).withOpacity(0.18)
                      : (isToday ? AppColors.primaryColor.withOpacity(0.12) : Colors.transparent),
                  borderRadius: BorderRadius.circular(6.r),
                  border: isBlocked
                      ? Border.all(color: const Color(0xFFF59E0B), width: 1.2)
                      : (isToday ? Border.all(color: AppColors.primaryColor, width: 1) : null),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isBlocked || isToday ? FontWeight.bold : FontWeight.normal,
                          color: isBlocked
                              ? const Color(0xFFF59E0B)
                              : (isToday
                                  ? AppColors.primaryColor
                                  : (isDark ? Colors.white70 : Colors.black87)),
                        ),
                      ),
                      if (isBlocked)
                        Container(
                          width: 4.w,
                          height: 4.w,
                          margin: EdgeInsets.only(top: 2.h),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 14.h),

          // Legend
          Wrap(
            spacing: 14.w,
            runSpacing: 6.h,
            children: [
              _buildLegendPill(color: const Color(0xFF10B981), label: 'Available', isDark: isDark),
              _buildLegendPill(color: const Color(0xFFF59E0B), label: 'Maintenance / Blocked', isDark: isDark),
            ],
          ),

          // Active Blocked Periods
          if (blockedWindows.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
            SizedBox(height: 8.h),
            Text(
              'Active Blocked Periods (${blockedWindows.length})',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Column(
              children: blockedWindows.map((w) {
                final start = DateFormat('MMM dd').format(w['start']);
                final end = DateFormat('MMM dd, yyyy').format(w['end']);
                return Container(
                  margin: EdgeInsets.only(bottom: 6.h),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.build_rounded, size: 14.sp, color: const Color(0xFFF59E0B)),
                          SizedBox(width: 8.w),
                          Text(
                            '$start - $end',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                      Text(
                        w['reason'] ?? 'Maintenance',
                        style: TextStyle(fontSize: 11.sp, color: isDark ? Colors.white54 : Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendPill({required Color color, required String label, required bool isDark}) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
      ],
    );
  }
}
