import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/filter_bottom_sheet.dart';
import 'search_bar_widget.dart';

class HeaderPromoWidget extends StatefulWidget {
  const HeaderPromoWidget({super.key});

  @override
  State<HeaderPromoWidget> createState() => _HeaderPromoWidgetState();
}

class _HeaderPromoWidgetState extends State<HeaderPromoWidget> {
  final PageController _promoController = PageController();
  Timer? _autoPlayTimer;
  int _currentPage = 0;
  static const int _totalPages = 5;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_promoController.hasClients) {
        _currentPage = (_currentPage + 1) % _totalPages;
        _promoController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(children: [_buildPromoCarousel()]),
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
          GestureDetector(
            onTap: () {
              FilterBottomSheet.show(context);
            },
            child: Icon(Icons.tune, color: Colors.white, size: 24.sp),
          ),
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
            children: [
              _buildPromoContent(
                title: 'Your Brand\nEverywhere in\nNigeria.',
                buttonText: 'Explore Advertisement Options',
              ),
              _buildPromoContent(
                title: 'Connect With\nTop Artists\nToday.',
                buttonText: 'Browse Artists',
                imagePath: 'assets/promotions/ayra2-removebg-preview.png',
              ),
              _buildPromoContent(
                title: 'Reach Millions\nAcross Nigeria\nNow.',
                buttonText: 'Get Started',
              ),
              _buildPromoContent(
                title: 'Secure &\nVerified\nServices.',
                buttonText: 'Vetting Available',
                onTap: () => context.push('/vetting'),
              ),
              _buildPromoContent(
                title: 'Free Design\nTemplates\nAvailable.',
                buttonText: 'Browse Templates',
                onTap: () => context.push('/template'),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: SmoothPageIndicator(
            controller: _promoController,
            count: 5,
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

  Widget _buildPromoContent({
    required String title,
    required String buttonText,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    // Split title into lines
    final lines = title.split('\n');
    final firstLine = lines.isNotEmpty ? lines[0] : '';
    final remainingLines = lines.length > 1 ? lines.sublist(1).join('\n') : '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // LEFT SIDE: TEXT
          Expanded(
            flex: imagePath != null ? 5 : 6,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main headline with orange and white text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$firstLine\n',
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF6B35), // Orange color
                            height: 1.2,
                          ),
                        ),
                        if (remainingLines.isNotEmpty)
                          TextSpan(
                            text: remainingLines,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // CTA Button
                  ElevatedButton(
                    onPressed: onTap ?? () {
                      // Navigate based on button text
                      if (buttonText == 'Explore Advertisement Options') {
                        context.push('/explore');
                      } else if (buttonText == 'Browse Artists') {
                        context.push('/explore?category=Artists');
                      } else if (buttonText == 'Get Started') {
                        context.push('/explore');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35), // Orange
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFFFF6B35).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 14.h,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward_rounded, size: 18.sp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // RIGHT SIDE: IMAGE (if provided)
          if (imagePath != null) ...[
            SizedBox(width: 16.w),
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 270.h,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
