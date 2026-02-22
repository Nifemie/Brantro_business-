import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../cart/logic/cart_notifier.dart';

/// Cart icon widget with badge and pulse animation
class CartIconWidget extends ConsumerStatefulWidget {
  final VoidCallback onTap;

  const CartIconWidget({
    super.key,
    required this.onTap,
  });

  @override
  ConsumerState<CartIconWidget> createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends ConsumerState<CartIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final itemCount = cartState.itemCount;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pulsing effect when cart has items
          if (itemCount > 0)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseAnimation.value * 0.15),
                  child: Container(
                    width: 24.sp,
                    height: 24.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF6B35).withOpacity(
                        0.3 * (1 - _pulseAnimation.value),
                      ),
                    ),
                  ),
                );
              },
            ),
          Icon(
            Icons.shopping_cart_outlined,
            color: itemCount > 0 ? Colors.white : const Color(0xFFFF6B35),
            size: 24.sp,
          ),
          if (itemCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                child: Text(
                  itemCount > 9 ? '9+' : '$itemCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
