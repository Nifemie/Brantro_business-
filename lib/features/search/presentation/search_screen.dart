import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data for last seen products
  final List<String> lastSeenProducts = [
    'assets/promotions/billboard1.jpg',
    'assets/promotions/billboard2.jpg',
    'assets/promotions/billboard3.jpg',
    'assets/promotions/billboard1.jpg',
    'assets/promotions/billboard2.jpg',
    'assets/promotions/billboard3.jpg',
  ];

  // Sample data for last searches
  List<String> lastSearches = [
    'adidas shirt',
    'led tv',
    'apple mac',
    'iphone',
    'asus',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeSearch(int index) {
    setState(() {
      lastSearches.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            
            // Last Seen Section
            _buildLastSeenSection(),
            
            SizedBox(height: 24.h),
            
            // Last Search Section
            _buildLastSearchSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.push('/search-results?query=$value');
          }
        },
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

  Widget _buildLastSeenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Last Seen',
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: lastSeenProducts.length,
            itemBuilder: (context, index) {
              return Container(
                width: 80.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: AssetImage(lastSeenProducts[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLastSearchSection() {
    if (lastSearches.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Last Search',
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lastSearches.length,
          itemBuilder: (context, index) {
            return _buildSearchHistoryItem(
              searchTerm: lastSearches[index],
              onRemove: () => _removeSearch(index),
              onTap: () {
                context.push('/search-results?query=${lastSearches[index]}');
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchHistoryItem({
    required String searchTerm,
    required VoidCallback onRemove,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: AppColors.grey400,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                searchTerm,
                style: AppTexts.bodyMedium(color: AppColors.grey600),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.grey400,
                size: 20.sp,
              ),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
