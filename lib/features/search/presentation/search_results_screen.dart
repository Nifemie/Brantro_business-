import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../controllers/re_useable/filter_bottom_sheet.dart';
import '../../home/presentation/widgets/reusable_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample product data
  final List<Map<String, dynamic>> products = [
    {
      'image': 'assets/promotions/billboard1.jpg',
      'name': 'iPhone 7 Plus / 7+ 128GB',
      'price': '\$ 433',
      'rating': 4.5,
      'location': 'Brooklyn',
      'reviews': 129,
    },
    {
      'image': 'assets/promotions/billboard2.jpg',
      'name': 'iWO 8 Smart Watch Apple iWatch Mirror For Android',
      'price': '\$ 62',
      'rating': 4.0,
      'reviews': 92,
    },
    {
      'image': 'assets/promotions/billboard3.jpg',
      'name': 'New iMac 2017 MNEA2 5K Retina /3.5GHZ/i5/8GB/',
      'price': '\$ 1,643',
      'rating': 5.0,
      'reviews': 2,
    },
    {
      'image': 'assets/promotions/Davido1.jpg',
      'name': 'APPLE AIRPODS PRO WITH WIRELESS CHARGING',
      'price': '\$ 219',
      'rating': 4.5,
      'reviews': 934,
    },
    {
      'image': 'assets/promotions/billboard1.jpg',
      'name': 'Apple TV 4K',
      'price': '\$ 179',
      'rating': 4.8,
      'reviews': 456,
    },
    {
      'image': 'assets/promotions/billboard2.jpg',
      'name': 'MacBook Pro 16"',
      'price': '\$ 2,399',
      'rating': 4.9,
      'reviews': 1234,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: AppColors.textPrimary),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ReusableCard(
              imageUrl: product['image'],
              title: product['name'],
              rating: product['rating'],
              amount: product['price'],
              onTap: () {
                // TODO: Navigate to product details
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: _searchController,
        readOnly: true,
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search product',
          hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.grey400,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    FilterBottomSheet.show(
      context,
      onApplyFilters: (filters) {
        // TODO: Apply filters to product list
        print('Filters applied: $filters');
      },
    );
  }
}
