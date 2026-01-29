import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/cart_item_model.dart';
import '../../logic/cart_notifier.dart';

class CartItemCard extends ConsumerWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTexts.h4(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                _buildTypeBadge(),
                SizedBox(height: 12.h),
                Text(
                  item.price,
                  style: AppTexts.h4(color: const Color(0xFF003D82)),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _ActionButton(
                      label: 'View Details',
                      onTap: () => _handleViewDetails(context),
                    ),
                    SizedBox(width: 8.w),
                    _ActionButton(
                      label: 'Remove',
                      isDestructive: true,
                      onTap: () => ref.read(cartProvider.notifier).removeItem(item.id, item.type),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 100.w,
        height: 100.h,
        color: AppColors.grey200,
        child: _hasValidImage()
            ? Image.network(
                item.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderIcon(),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : _placeholderIcon(),
      ),
    );
  }

  bool _hasValidImage() {
    return item.imageUrl != null && 
           item.imageUrl!.isNotEmpty && 
           item.imageUrl!.startsWith('http');
  }

  Widget _placeholderIcon() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        color: AppColors.grey400,
        size: 32.sp,
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Text(
        item.sellerType?.toUpperCase() ?? 'TEMPLATE',
        style: AppTexts.labelSmall(color: AppColors.grey600),
      ),
    );
  }

  void _handleViewDetails(BuildContext context) {
    switch (item.type) {
      case 'service':
        context.push('/service-details/${item.id}');
        break;
      case 'adslot':
        if (item.metadata.containsKey('asset')) {
          context.push('/asset-details', extra: item.metadata['asset']);
        } else {
          context.push('/ad-slot-details/${item.id}');
        }
        break;
      case 'template':
        context.push('/template-details/${item.id}');
        break;
      case 'creative':
        context.push('/creative-details/${item.id}');
        break;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDestructive ? Colors.red : Colors.orange,
          ),
        ),
        child: Text(
          label,
          style: AppTexts.labelSmall(
            color: isDestructive ? Colors.white : Colors.orange,
          ),
        ),
      ),
    );
  }
}
