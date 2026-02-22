import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../logic/cart_notifier.dart';

class CheckoutHeader extends ConsumerWidget {
  final String transactionReference;
  final String checkoutType;

  const CheckoutHeader({
    super.key,
    required this.transactionReference,
    required this.checkoutType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = _getTitle();
    final subtitle = _getSubtitle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTexts.h2()),
        SizedBox(height: 4.h),
        Text(subtitle, style: AppTexts.bodySmall(color: AppColors.grey600)),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ActionPill(text: transactionReference),
              SizedBox(width: 8.w),
              _ActionPill(
                text: 'Clear All',
                icon: Icons.delete_outline,
                onTap: () => ref.read(cartProvider.notifier).clearCart(),
              ),
              SizedBox(width: 8.w),
              _ActionPill(
                text: 'Get More',
                icon: Icons.add_circle_outline,
                isPrimary: true,
                onTap: () => _navigateToListingScreen(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    if (checkoutType == 'campaign') return 'Campaign Checkout';
    if (checkoutType == 'service') return 'Service Checkout';
    if (checkoutType == 'creative') return 'Creative Checkout';
    return 'Template Checkout';
  }

  String _getSubtitle() {
    if (checkoutType == 'campaign') {
      return 'Review your campaign items and complete payment.';
    }
    if (checkoutType == 'service') {
      return 'Review selected services and complete payment.';
    }
    if (checkoutType == 'creative') {
      return 'Review selected creatives and complete payment.';
    }
    return 'Review selected templates and complete payment.';
  }

  void _navigateToListingScreen(BuildContext context) {
    switch (checkoutType) {
      case 'service':
        context.push('/services');
        break;
      case 'creative':
        context.push('/creatives');
        break;
      case 'campaign':
        context.push('/explore?category=Ad Slots');
        break;
      default:
        context.push('/templates');
    }
  }
}

class _ActionPill extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _ActionPill({
    required this.text,
    this.icon,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF003D82) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isPrimary ? const Color(0xFF003D82) : Colors.orange,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: isPrimary ? Colors.white : Colors.orange),
              SizedBox(width: 6.w),
            ],
            Text(
              text,
              style: AppTexts.labelSmall(color: isPrimary ? Colors.white : Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
