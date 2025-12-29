import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../controllers/re_useable/filter_bottom_sheet.dart';
import '../../home/presentation/widgets/reusable_card.dart';

class ExploreScreen extends StatefulWidget {
  final String? category;

  const ExploreScreen({
    super.key,
    this.category,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedSort = 'Recommended';

  // Sample listings data
  final List<Map<String, dynamic>> listings = [
    {
      'image': 'assets/promotions/Davido1.jpg',
      'name': 'Davido - Instagram Influencer',
      'category': 'Influencer',
      'location': 'Lagos',
      'price': '\$ 5,000',
      'rating': 4.9,
    },
    {
      'image': 'assets/promotions/billboard1.jpg',
      'name': 'Cool FM 96.9 - Radio Station',
      'category': 'Radio',
      'location': 'Lagos',
      'price': '\$ 2,500',
      'rating': 4.7,
    },
    {
      'image': 'assets/promotions/billboard2.jpg',
      'name': 'Channels TV - Television',
      'category': 'TV Station',
      'location': 'Abuja',
      'price': '\$ 8,000',
      'rating': 4.8,
    },
    {
      'image': 'assets/promotions/billboard3.jpg',
      'name': 'Lekki Billboard - Outdoor',
      'category': 'Billboard',
      'location': 'Lagos',
      'price': '\$ 15,000',
      'rating': 4.6,
    },
    {
      'image': 'assets/promotions/Davido1.jpg',
      'name': 'Wizkid - Music Artist',
      'category': 'Artist',
      'location': 'Lagos',
      'price': '\$ 10,000',
      'rating': 5.0,
    },
    {
      'image': 'assets/promotions/billboard1.jpg',
      'name': 'Beat FM - Radio Station',
      'category': 'Radio',
      'location': 'Lagos',
      'price': '\$ 3,000',
      'rating': 4.5,
    },
    {
      'image': 'assets/promotions/billboard2.jpg',
      'name': 'NTA - National Television',
      'category': 'TV Station',
      'location': 'Abuja',
      'price': '\$ 6,500',
      'rating': 4.4,
    },
    {
      'image': 'assets/promotions/billboard3.jpg',
      'name': 'VI Billboard - Premium Outdoor',
      'category': 'Billboard',
      'location': 'Lagos',
      'price': '\$ 20,000',
      'rating': 4.7,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _getCategoryImage() {
    if (widget.category == null) return null;
    
    final category = widget.category!.toLowerCase();
    if (category.contains('artist')) return 'assets/promotions/Davido1.jpg';
    if (category.contains('billboard')) return 'assets/promotions/billboard1.jpg';
    if (category.contains('tv') || category.contains('television')) return 'assets/promotions/billboard2.jpg';
    if (category.contains('radio')) return 'assets/promotions/billboard3.jpg';
    if (category.contains('influencer')) return 'assets/promotions/Davido1.jpg';
    if (category.contains('media')) return 'assets/promotions/billboard2.jpg';
    if (category.contains('digital') || category.contains('screen')) return 'assets/promotions/billboard3.jpg';
    if (category.contains('designer') || category.contains('creative')) return 'assets/promotions/billboard1.jpg';
    
    return 'assets/promotions/Davido1.jpg'; // Default
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: AppColors.backgroundPrimary,
        child: Column(
          children: [
            // Category header image (if category is selected)
            if (widget.category != null && _getCategoryImage() != null)
              Stack(
                children: [
                  // Category image
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_getCategoryImage()!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category title overlay
                  Positioned(
                    bottom: 20.h,
                    left: 16.w,
                    right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category!,
                          style: AppTexts.h1(color: Colors.white),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Explore ${widget.category!.toLowerCase()}',
                          style: AppTexts.bodyMedium(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // Fixed top section with SafeArea
            SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    _buildSearchBar(),
                    SizedBox(height: 16.h),

                    // Filter & Sort row
                    _buildFilterSortRow(),
                  ],
                ),
              ),
            ),

            // Scrollable listings grid
            Expanded(
              child: _buildListingsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search by name, location, platform…',
          hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.grey400,
            size: 24.sp,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.grey400, size: 20.sp),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilterSortRow() {
    return Row(
      children: [
        // Filter button
        Expanded(
          child: GestureDetector(
            onTap: () {
              FilterBottomSheet.show(context);
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.grey300,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, color: AppColors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Filter',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Sort dropdown
        Expanded(
          child: PopupMenuButton<String>(
            initialValue: selectedSort,
            onSelected: (value) {
              setState(() {
                selectedSort = value;
              });
            },
            offset: Offset(0, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            itemBuilder: (context) => [
              _buildSortMenuItem('Recommended'),
              _buildSortMenuItem('Price: Low to High'),
              _buildSortMenuItem('Price: High to Low'),
              _buildSortMenuItem('Most Booked'),
              _buildSortMenuItem('Rating'),
            ],
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.grey300,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, color: AppColors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      'Sort',
                      style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_drop_down, color: AppColors.grey400, size: 20.sp),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: AppTexts.bodyMedium(
          color: selectedSort == value ? AppColors.primaryColor : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildListingsGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.68,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return ReusableCard(
          imageUrl: listing['image'],
          title: listing['name'],
          rating: listing['rating'],
          amount: listing['price'],
          onTap: () {
            context.push('/product-details', extra: listing);
          },
        );
      },
    );
  }
}
