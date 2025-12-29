import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../controllers/re_useable/custom_tab_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroImage(),
            _buildProductInfoCard(),
            SizedBox(height: 16.h),
            _buildTabSection(),
            SizedBox(height: 16.h),
            _buildPricingSection(),
            SizedBox(height: 16.h),
            _buildSellerInfo(),
            SizedBox(height: 100.h), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 400.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.product['image'] ?? 'assets/promotions/Davido1.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              widget.product['category'] ?? 'Category',
              style: AppTexts.labelSmall(color: AppColors.primaryColor),
            ),
          ),
          SizedBox(height: 12.h),

          // Product name
          Text(
            widget.product['name'] ?? 'Product Name',
            style: AppTexts.h2(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: AppColors.grey500),
              SizedBox(width: 4.w),
              Text(
                widget.product['location'] ?? 'Location',
                style: AppTexts.bodyMedium(color: AppColors.grey600),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Rating
          Row(
            children: [
              Icon(Icons.star, size: 20.sp, color: Colors.amber),
              SizedBox(width: 4.w),
              Text(
                '${widget.product['rating'] ?? 4.5}',
                style: AppTexts.labelLarge(color: AppColors.textPrimary),
              ),
              SizedBox(width: 4.w),
              Text(
                '(120 reviews)',
                style: AppTexts.bodySmall(color: AppColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          CustomTabBar(
            tabs: const ['Description', 'Overview', 'Reviews'],
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          SizedBox(height: 16.h),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildDescriptionTab();
      case 1:
        return _buildOverviewTab();
      case 2:
        return _buildReviewsTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDescriptionTab() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        'This is a premium advertising opportunity that will help you reach your target audience effectively. '
        'With proven results and high engagement rates, this platform offers excellent value for your marketing investment. '
        'Perfect for brands looking to increase visibility and drive conversions.',
        style: AppTexts.bodyMedium(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewItem('Platform', 'Instagram, Twitter, Facebook'),
          _buildOverviewItem('Reach', '2M+ followers'),
          _buildOverviewItem('Engagement Rate', '8.5%'),
          _buildOverviewItem('Duration', 'Flexible'),
          _buildOverviewItem('Availability', 'Available Now'),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTexts.bodyMedium(color: AppColors.grey600),
          ),
          Text(
            value,
            style: AppTexts.labelLarge(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: List.generate(
          3,
          (index) => _buildReviewItem(),
        ),
      ),
    );
  }

  Widget _buildReviewItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.grey200,
                child: Icon(Icons.person, color: AppColors.grey500),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: AppTexts.labelLarge(color: AppColors.textPrimary),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 14.sp,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '2 days ago',
                style: AppTexts.bodySmall(color: AppColors.grey500),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Great service! Highly recommend for anyone looking to boost their brand visibility.',
            style: AppTexts.bodyMedium(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.grey300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.product['price'] ?? '\$5,000',
                style: AppTexts.h1(color: AppColors.textPrimary),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Available',
              style: AppTexts.labelMedium(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.grey200,
            child: Icon(Icons.person, size: 30.sp, color: AppColors.grey500),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seller Name',
                  style: AppTexts.labelLarge(color: AppColors.textPrimary),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star, size: 16.sp, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      '4.8 (50 reviews)',
                      style: AppTexts.bodySmall(color: AppColors.grey600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.message, color: AppColors.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Book Now',
                  style: AppTexts.buttonLarge(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondaryColor, width: 2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: AppColors.secondaryColor),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
