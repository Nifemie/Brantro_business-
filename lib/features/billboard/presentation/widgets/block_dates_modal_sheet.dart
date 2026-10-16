import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../logic/billboard_provider.dart';

class BlockDatesModalSheet extends ConsumerStatefulWidget {
  final dynamic locationId;
  final bool isDark;
  final VoidCallback? onDatesUpdated;

  const BlockDatesModalSheet({
    super.key,
    required this.locationId,
    required this.isDark,
    this.onDatesUpdated,
  });

  static Future<void> show({
    required BuildContext context,
    required dynamic locationId,
    required bool isDark,
    VoidCallback? onDatesUpdated,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlockDatesModalSheet(
        locationId: locationId,
        isDark: isDark,
        onDatesUpdated: onDatesUpdated,
      ),
    );
  }

  @override
  ConsumerState<BlockDatesModalSheet> createState() => _BlockDatesModalSheetState();
}

class _BlockDatesModalSheetState extends ConsumerState<BlockDatesModalSheet> {
  DateTimeRange? _selectedRange;
  final _reasonController = TextEditingController();
  String _selectedType = 'MAINTENANCE';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleBlockDatesSubmit() async {
    if (_selectedRange == null) return;
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(billboardRepositoryProvider);
      await repo.blockLocationDates(
        locationId: widget.locationId,
        startDate: _selectedRange!.start.toIso8601String(),
        endDate: _selectedRange!.end.toIso8601String(),
        reason: _reasonController.text.trim().isNotEmpty
            ? _reasonController.text.trim()
            : 'Routine Maintenance',
        type: _selectedType,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dates blocked successfully for maintenance.'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onDatesUpdated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to block dates: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isReady = _selectedRange != null && !_isSubmitting;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Block Dates for Maintenance',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Date Range Selector
              Text(
                'SELECT DATE RANGE',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDateRange: _selectedRange,
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: AppColors.primaryColor,
                          primary: AppColors.primaryColor,
                          brightness: isDark ? Brightness.dark : Brightness.light,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setState(() => _selectedRange = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedRange != null
                          ? AppColors.primaryColor
                          : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                      width: _selectedRange != null ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    color: isDark ? Colors.grey[850] : Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: _selectedRange != null ? AppColors.primaryColor : Colors.grey,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _selectedRange != null
                              ? '${DateFormat('MMM dd, yyyy').format(_selectedRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_selectedRange!.end)}'
                              : 'Tap to choose start and end dates',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: _selectedRange != null ? FontWeight.w600 : FontWeight.normal,
                            color: _selectedRange != null
                                ? (isDark ? Colors.white : Colors.black87)
                                : (isDark ? Colors.white54 : Colors.grey[500]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Block Reason Type
              Text(
                'BLOCK REASON TYPE',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12.r),
                  color: isDark ? Colors.grey[850] : Colors.grey[50],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                    items: const [
                      DropdownMenuItem(value: 'MAINTENANCE', child: Text('Routine Maintenance / Servicing')),
                      DropdownMenuItem(value: 'INTERNAL_RESERVED', child: Text('Internal / Government Reservation')),
                      DropdownMenuItem(value: 'OFFLINE', child: Text('Offline / Power Interruption')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Note
              Text(
                'NOTE / DESCRIPTION',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _reasonController,
                maxLines: 2,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'e.g., Structural repainting and LED module replacement',
                  hintStyle: TextStyle(fontSize: 13.sp, color: isDark ? Colors.white38 : Colors.grey[400]),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: isReady ? _handleBlockDatesSubmit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isReady ? AppColors.primaryColor : (isDark ? Colors.grey[800] : Colors.grey[300]),
                    foregroundColor: isReady ? Colors.white : (isDark ? Colors.white38 : Colors.grey[500]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: isReady ? 2 : 0,
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          _selectedRange == null ? 'Select Date Range First' : 'Confirm & Block Dates',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
