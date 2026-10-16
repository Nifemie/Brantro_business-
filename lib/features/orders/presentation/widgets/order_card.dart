import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/order_model.dart';
import 'order_card_components/order_card_creator.dart';
import 'order_card_components/order_card_details.dart';
import 'order_card_components/order_card_footer.dart';
import 'order_card_components/order_card_header.dart';
import 'order_card_components/order_card_title.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Extracted slate blue color used in the design
    final Color titleColor = isDark ? Colors.white : const Color(0xFF2B4162);
    final Color valueColor = isDark ? Colors.white : const Color(0xFF2B4162);
    final Color labelColor = isDark ? Colors.grey[400]! : const Color(0xFF7D8C9C);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderCardHeader(order: order, isDark: isDark),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderCardTitle(
                    order: order, 
                    isDark: isDark, 
                    titleColor: titleColor, 
                    labelColor: labelColor,
                  ),
                  SizedBox(height: 20.h),
                  OrderCardDetails(
                    order: order, 
                    titleColor: titleColor, 
                    labelColor: labelColor, 
                    valueColor: valueColor,
                  ),
                  SizedBox(height: 24.h),
                  OrderCardCreator(
                    order: order, 
                    titleColor: titleColor, 
                    labelColor: labelColor,
                  ),
                  SizedBox(height: 20.h),
                  Divider(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    height: 1,
                  ),
                  SizedBox(height: 16.h),
                  OrderCardFooter(
                    order: order, 
                    isDark: isDark, 
                    titleColor: titleColor, 
                    labelColor: labelColor, 
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
