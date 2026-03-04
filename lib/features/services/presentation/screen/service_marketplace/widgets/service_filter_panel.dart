import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceFilterPanel extends StatefulWidget {
  const ServiceFilterPanel({super.key});

  @override
  State<ServiceFilterPanel> createState() => _ServiceFilterPanelState();
}

class _ServiceFilterPanelState extends State<ServiceFilterPanel> {
  String _selectedCategory = 'All';
  String _selectedCost = '';
  String _selectedRating = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final outerBgColor = isDark ? const Color(0xFF22272B) : Colors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: outerBgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(
            title: 'Categories',
            items: [
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
            ],
            selectedValue: _selectedCategory,
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
          SizedBox(height: 32.h),

          _buildFilterSection(
            title: 'Cost',
            items: ['Free', 'Paid', 'Sold'],
            selectedValue: _selectedCost,
            onChanged: (val) => setState(() => _selectedCost = val),
          ),
          SizedBox(height: 32.h),

          _buildFilterSection(
            title: 'Rating',
            items: [
              '1 Star & Above',
              '2 Star & Above',
              '3 Star & Above',
              '4 Star & Above',
            ],
            selectedValue: _selectedRating,
            onChanged: (val) => setState(() => _selectedRating = val),
            isRating: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> items,
    required String selectedValue,
    required ValueChanged<String> onChanged,
    bool isRating = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headerBgColor = isDark ? const Color(0xFF2D333B) : Colors.grey[100]!;
    final textColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final activeTextColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: headerBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Items
        ...items.map((item) {
          final isSelected =
              selectedValue == item || (item == 'All' && selectedValue.isEmpty);

          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: InkWell(
              onTap: () => onChanged(item),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  // Custom Radio Button
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey[600]!,
                        width: 1.5,
                      ),
                      color: isSelected
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),

                  // Text and optional star logic
                  if (isRating) ...[
                    // E.g., item = "1 Star & Above" -> "1", "Star & Above"
                    Text(
                      item[0],
                      style: TextStyle(
                        color: isSelected ? activeTextColor : textColor,
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '& Above',
                      style: TextStyle(
                        color: isSelected ? activeTextColor : textColor,
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ] else ...[
                    Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? activeTextColor : textColor,
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
