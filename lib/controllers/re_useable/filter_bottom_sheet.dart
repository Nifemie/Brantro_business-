import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_color.dart';
import 'app_texts.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.onApplyFilters,
  });

  static void show(
    BuildContext context, {
    Function(Map<String, dynamic>)? onApplyFilters,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(onApplyFilters: onApplyFilters),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedRole;
  String? selectedCategory;
  String selectedSort = 'Relevant Product';

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: AppTexts.h3(color: AppColors.textPrimary),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedRole = null;
                            selectedCategory = null;
                            selectedSort = 'Relevant Product';
                          });
                        },
                        child: Text(
                          'Reset',
                          style: AppTexts.bodyMedium(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Sort section
                  Text(
                    'Sort By',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterChip('Relevant', selectedSort == 'Relevant Product', () {
                        setState(() => selectedSort = 'Relevant Product');
                      }),
                      _buildFilterChip('Review', selectedSort == 'Review', () {
                        setState(() => selectedSort = 'Review');
                      }),
                      _buildFilterChip('Newest', selectedSort == 'Newest Product', () {
                        setState(() => selectedSort = 'Newest Product');
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Roles Section
                  Text(
                    'User Roles',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      'ARTIST',
                      'INFLUENCER',
                      'PRODUCER',
                      'UGC_CREATOR',
                      'DESIGNER',
                      'TALENT_MANAGER',
                    ].map((role) {
                      return _buildFilterChip(
                        role.replaceAll('_', ' '),
                        selectedRole == role,
                        () {
                          setState(() => selectedRole = (selectedRole == role ? null : role));
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),

                  // Ad Slot Categories
                  Text(
                    'Ad Slot Categories',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      'BILLBOARD',
                      'TV_STATION',
                      'RADIO_STATION',
                      'DIGITAL_SCREEN',
                      'SOCIAL_MEDIA',
                    ].map((cat) {
                      return _buildFilterChip(
                        cat.replaceAll('_', ' '),
                        selectedCategory == cat,
                        () {
                          setState(() => selectedCategory = (selectedCategory == cat ? null : cat));
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),

          // Action Button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onApplyFilters != null) {
                    widget.onApplyFilters!({
                      'role': selectedRole,
                      'category': selectedCategory,
                      'sort': selectedSort,
                    });
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Apply Filter',
                  style: AppTexts.bodyLarge(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.grey300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTexts.bodySmall(
            color: isSelected ? Colors.white : AppColors.grey600,
          ),
        ),
      ),
    );
  }
}
