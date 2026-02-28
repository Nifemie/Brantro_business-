import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class TopPagesTable extends StatelessWidget {
  const TopPagesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Pages',
                  style: AppTexts.h3(color: AppColors.primaryColor),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'View All',
                    style: AppTexts.labelMedium(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table data
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFEFF1F5),
              ),
              dataRowMinHeight: 60.h,
              dataRowMaxHeight: 60.h,
              horizontalMargin: 20.w,
              columnSpacing: 40.w,
              dividerThickness: 1,
              columns: [
                DataColumn(
                  label: Text(
                    'Page Path',
                    style: AppTexts.labelLarge(color: AppColors.textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Page Views',
                    style: AppTexts.labelLarge(color: AppColors.textSecondary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Exit Rate',
                    style: AppTexts.labelLarge(color: AppColors.textSecondary),
                  ),
                ),
              ],
              rows: [
                _buildRow(
                  'larkon/ecommerce.html',
                  '465',
                  '4.4%',
                  _RateType.positive,
                ),
                _buildRow(
                  'larkon/dashboard.html',
                  '426',
                  '20.4%',
                  _RateType.negative,
                ),
                _buildRow(
                  'larkon/chat.html',
                  '254',
                  '12.25%',
                  _RateType.warning,
                ),
                _buildRow(
                  'larkon/auth-login.html',
                  '3369',
                  '5.2%',
                  _RateType.positive,
                ),
                _buildRow(
                  'larkon/email.html',
                  '985',
                  '64.2%',
                  _RateType.negative,
                ),
                _buildRow(
                  'larkon/social.html',
                  '653',
                  '2.4%',
                  _RateType.positive,
                ),
                _buildRow(
                  'larkon/blog.html',
                  '478',
                  '1.4%',
                  _RateType.negative,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  DataRow _buildRow(String path, String views, String rate, _RateType type) {
    Color badgeColor;
    Color textColor;

    switch (type) {
      case _RateType.positive:
        badgeColor = AppColors.success.withOpacity(0.1); // Light green
        textColor = AppColors.success; // Green
        break;
      case _RateType.negative:
        badgeColor = AppColors.error.withOpacity(0.1); // Light red
        textColor = AppColors.error; // Red
        break;
      case _RateType.warning:
        badgeColor = AppColors.warning.withOpacity(0.1); // Light yellow
        textColor = AppColors.warning; // Yellow
        break;
    }

    return DataRow(
      cells: [
        DataCell(
          Text(path, style: AppTexts.bodyMedium(color: AppColors.grey700)),
        ),
        DataCell(
          Text(views, style: AppTexts.bodyMedium(color: AppColors.grey700)),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              rate,
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _RateType { positive, negative, warning }
