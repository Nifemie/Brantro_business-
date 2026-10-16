import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/order_model.dart';
import '../../../../core/network/api_client.dart';

class OrderItemsCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderItemsCard({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = [];
    if (order.metadata != null) {
      if (order.metadata!.containsKey('creatives')) {
        items = order.metadata!['creatives'] as List<dynamic>? ?? [];
      } else if (order.metadata!.containsKey('templates')) {
        items = order.metadata!['templates'] as List<dynamic>? ?? [];
      } else if (order.metadata!.containsKey('items')) {
        items = order.metadata!['items'] as List<dynamic>? ?? [];
      }
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
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
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: Theme.of(context).primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Items (${items.length})',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              height: 24.h,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemRow(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, Map<String, dynamic> item) {
    // Determine how to extract the thumbnail/title since structure varies
    String? thumbnail = item['thumbnail'];
    String? title = item['title'];
    String? price = item['price'];
    
    // For service-order, the nested object is under 'service'
    if (item.containsKey('service')) {
      final service = item['service'] as Map<String, dynamic>;
      thumbnail ??= service['thumbnail'];
      title ??= service['title'];
      price ??= service['price'];
    }

    final parsedPrice = double.tryParse(price?.toString() ?? '0') ?? 0.0;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (thumbnail != null)
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage('${ApiClient.fileBaseUrl}/$thumbnail'),
                fit: BoxFit.cover,
                onError: (e, s) => const SizedBox(),
              ),
            ),
          )
        else
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Unknown Item',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              if (parsedPrice > 0)
                Text(
                  'NGN ${parsedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              SizedBox(height: 4.h),
              if (item['status'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    item['status'].toString(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
