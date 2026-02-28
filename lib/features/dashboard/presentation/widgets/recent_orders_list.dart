import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(
          isDark ? Colors.grey[850] : AppColors.grey50,
        ),
        headingRowHeight: 80.h,
        dataRowMinHeight: 80.h,
        dataRowMaxHeight: 80.h,
        horizontalMargin: 30.w,
        columnSpacing: 45.w,
        dividerThickness: 1,
        headingTextStyle: AppTexts.labelLarge(
          color: isDark ? Colors.white : Colors.black,
        ).copyWith(fontWeight: FontWeight.bold),
        columns: const [
          DataColumn(label: Text('Order\nID.')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Customer\nName')),
          DataColumn(label: Text('Email ID')),
          DataColumn(label: Text('Phone\nNo.')),
          DataColumn(label: Text('Address')),
          DataColumn(label: Text('Payment\nType')),
          DataColumn(label: Text('Status')),
        ],
        rows: [
          _buildRow(
            context,
            id: '#1001',
            date: '29\nApril\n2024',
            imagePath: 'assets/products/tshirt.png',
            customer: 'Anna M.\nHines',
            email: 'anna.hines@mail.com',
            phone: '(+1)-555-\n1564-261',
            address: 'Burr Ridge/ Illinois',
            payment: 'Credit\nCard',
            status: 'Completed',
            statusColor: AppColors.success,
          ),
          _buildRow(
            context,
            id: '#1002',
            date: '29\nApril\n2024',
            imagePath: 'assets/products/handbag.png',
            customer: 'Judith H.\nFritsche',
            email: 'judith.fritsche.com',
            phone: '(+57)-305-\n5579-759',
            address: 'SULLIVAN/Kentucky',
            payment: 'Google\nPay',
            status: 'Delivered',
            statusColor: AppColors.secondaryColor,
          ),
          _buildRow(
            context,
            id: '#1003',
            date: '29\nApril\n2024',
            imagePath: 'assets/products/dress.png',
            customer: 'Peter T.\nSmith',
            email: 'peter.smith@mail.com',
            phone: '(+33)-655-\n5187-93',
            address: 'Yreka/California',
            payment: 'Pay Pal',
            status: 'Completed',
            statusColor: AppColors.success,
          ),
          _buildRow(
            context,
            id: '#1004',
            date: '29\nApril\n2024',
            imagePath: 'assets/products/cap.png',
            customer: 'Emmanuel\nJ. Delcid',
            email: 'emmanuel.delicid@mail.com',
            phone: '(+30)-693-\n5553-637',
            address: 'Atlanta/Georgia',
            payment: 'Pay Pal',
            status: 'Processing',
            statusColor: AppColors.warning,
          ),
          _buildRow(
            context,
            id: '#1005',
            date: '29\nApril\n2024',
            imagePath: 'assets/products/pants.png',
            customer: 'William J.\nCook',
            email: 'william.cook@mail.com',
            phone: '(+91)-855-\n5446-150',
            address: 'Rosenberg/Texas',
            payment: 'Credit\nCard',
            status: 'Processing',
            statusColor: AppColors.warning,
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(
    BuildContext context, {
    required String id,
    required String date,
    required String imagePath,
    required String customer,
    required String email,
    required String phone,
    required String address,
    required String payment,
    required String status,
    required Color statusColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = AppTexts.bodyMedium(
      color: isDark ? Colors.white : AppColors.grey700,
    ).copyWith(height: 1.5, fontSize: 13.sp);

    return DataRow(
      cells: [
        DataCell(Text(id, style: style)),
        DataCell(Text(date, style: style)),
        DataCell(
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        DataCell(Text(customer, style: style)),
        DataCell(Text(email, style: style)),
        DataCell(Text(phone, style: style)),
        DataCell(Text(address, style: style)),
        DataCell(Text(payment, style: style)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(status, style: style),
            ],
          ),
        ),
      ],
    );
  }
}
