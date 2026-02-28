import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';

class TemplateFilterSheet extends StatefulWidget {
  const TemplateFilterSheet({super.key});

  @override
  State<TemplateFilterSheet> createState() => _TemplateFilterSheetState();
}

class _TemplateFilterSheetState extends State<TemplateFilterSheet> {
  String? selectedCategory;
  String? selectedCost;
  String? selectedRating;

  final List<String> categories = [
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

  final List<String> costOptions = [
    'Free',
    'Paid',
    'Sold',
  ];

  final List<Map<String, dynamic>> ratingOptions = [
    {'label': '1 ⭐ & Above', 'value': '1'},
    {'label': '2 ⭐ & Above', 'value': '2'},
    {'label': '3 ⭐ & Above', 'value': '3'},
    {'label': '4 ⭐ & Above', 'value': '4'},
    {'label': '5 ⭐', 'value': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : AppColors.grey300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: isDark ? Colors.white70 : AppColors.grey700,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: isDark ? Colors.grey[800] : AppColors.grey200),

          // Filter Content - Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  _buildSectionHeader('Categories'),
                  SizedBox(height: 12.h),
                  ...categories.map((category) => _buildRadioOption(
                        label: category,
                        value: category,
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() => selectedCategory = value);
                        },
                      )),

                  SizedBox(height: 24.h),

                  // Cost Section
                  _buildSectionHeader('Cost'),
                  SizedBox(height: 12.h),
                  ...costOptions.map((cost) => _buildRadioOption(
                        label: cost,
                        value: cost,
                        groupValue: selectedCost,
                        onChanged: (value) {
                          setState(() => selectedCost = value);
                        },
                      )),

                  SizedBox(height: 24.h),

                  // Rating Section
                  _buildSectionHeader('Rating'),
                  SizedBox(height: 12.h),
                  ...ratingOptions.map((rating) => _buildRadioOption(
                        label: rating['label'],
                        value: rating['value'],
                        groupValue: selectedRating,
                        onChanged: (value) {
                          setState(() => selectedRating = value);
                        },
                      )),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Action Buttons - Always visible at bottom
          Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final isDark = theme.brightness == Brightness.dark;
              
              return Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? Colors.grey[800]! : AppColors.grey200,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory = null;
                              selectedCost = null;
                              selectedRating = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(
                              color: isDark ? Colors.grey[700]! : AppColors.grey300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : AppColors.grey700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Return selected filters
                            Navigator.pop(context, {
                              'category': selectedCategory,
                              'cost': selectedCost,
                              'rating': selectedRating,
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : AppColors.grey100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.grey700,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioOption({
    required String label,
    required String value,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = value == groupValue;
    
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return InkWell(
          onTap: () => onChanged(value),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : (isDark ? Colors.grey[600]! : AppColors.grey400),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelected 
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : (isDark ? Colors.white60 : AppColors.grey600),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
