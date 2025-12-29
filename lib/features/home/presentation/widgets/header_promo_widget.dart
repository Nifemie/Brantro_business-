import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'search_bar_widget.dart';

class HeaderPromoWidget extends StatefulWidget {
  const HeaderPromoWidget({super.key});

  @override
  State<HeaderPromoWidget> createState() => _HeaderPromoWidgetState();
}

class _HeaderPromoWidgetState extends State<HeaderPromoWidget> {
  final PageController _promoController = PageController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4EAD), Color(0xFF21899C)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [_buildSearchAndActionsRow(), _buildPromoCarousel()],
        ),
      ),
    );
  }

  // --- Layout Helper Widgets ---

  Widget _buildSearchAndActionsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: SearchBarWidget(
              hintText: 'Search Product',
              readOnly: true,
              onTap: () => context.push('/search'),
            ),
          ),
          SizedBox(width: 12.w),
          Icon(Icons.mail_outline, color: Colors.white, size: 24.sp),
          SizedBox(width: 12.w),
          _buildNotificationIcon(),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () => context.push('/notification'),
      child: Stack(
        children: [
          Icon(Icons.notifications_none, color: Colors.white, size: 24.sp),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFFE57373),
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 12.w, minHeight: 12.h),
              child: Text(
                '8',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7.sp,
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

  Widget _buildPromoCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 320.h, // Fixed height for the carousel
          child: PageView(
            controller: _promoController,
            children: [_buildPromoContent()],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: SmoothPageIndicator(
            controller: _promoController,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.white,
              dotColor: Colors.white.withOpacity(0.5),
              dotHeight: 4.h,
              dotWidth: 8.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // LEFT SIDE: TEXT (Wrapped in FittedBox to prevent any overflow)
          Expanded(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Credit Card Promo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Sale up to',
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                  // TYPOGRAPHY FOR "40% OFF"
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '40',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, -20), // Moves % higher up
                            child: Text(
                              '%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Pay with credit card and get\nthe discount',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11.sp,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
