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
  static const int _totalPages = 9;

  final List<String> _promoImages = [
    'assets/promotions/intro4.jpg',
    'assets/promotions/intro5.jpg',
    'assets/promotions/intro3.jpg',
    'assets/promotions/billboard2.jpg',
    'assets/promotions/billboard3.jpg',
    'assets/promotions/billboard1.jpg',
    'assets/promotions/radio1.jpg',
    'assets/promotions/radio2.png',
    'assets/promotions/tv1.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_promoController.hasClients) {
        _currentPage = (_currentPage + 1) % _totalPages;
        _promoController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
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
    return SafeArea(
      bottom: false,
      child: _buildPromoCarousel(),
    );
  }

  Widget _buildPromoCarousel() {
    return Stack(
      children: [
        SizedBox(
          height: 240.h,
          child: PageView.builder(
            controller: _promoController,
            itemCount: _promoImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPromoImage(_promoImages[index]);
            },
          ),
        ),
        Positioned(
          bottom: 12.h,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _promoController,
              count: _totalPages,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white.withOpacity(0.5),
                dotHeight: 6.h,
                dotWidth: 10.w,
                expansionFactor: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoImage(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.primaryColor.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.white.withOpacity(0.5),
              size: 48.sp,
            ),
          ),
        );
      },
    );
  }
}
