import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/service/local_storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final history = await LocalStorageService.getSearchHistory();
    setState(() {
      _searchHistory = history;
      _isLoading = false;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    // Save to history
    await LocalStorageService.addSearchHistory(query.trim());
    
    // Navigate to results
    if (mounted) {
      context.push('/search-results?query=${query.trim()}');
    }
  }

  Future<void> _removeSearchItem(String query) async {
    await LocalStorageService.removeSearchHistory(query);
    await _loadSearchHistory();
  }

  Future<void> _clearAllHistory() async {
    await LocalStorageService.clearSearchHistory();
    await _loadSearchHistory();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchHistory.isEmpty
              ? _buildEmptyState()
              : _buildSearchHistory(),
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
        onSubmitted: _performSearch,
        decoration: InputDecoration(
          hintText: 'Search ad slots & users',
          hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
          prefixIcon: Icon(Icons.search, color: AppColors.grey400, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.sp,
              color: AppColors.grey300,
            ),
            SizedBox(height: 16.h),
            Text(
              'Search for ad slots and users',
              style: AppTexts.h4(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Find billboards, artists, influencers, and more',
              style: AppTexts.bodySmall(color: AppColors.grey400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTexts.h4(color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: _clearAllHistory,
                child: Text(
                  'Clear All',
                  style: AppTexts.bodySmall(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final query = _searchHistory[index];
              return InkWell(
                onTap: () => _performSearch(query),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: AppColors.grey400,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          query,
                          style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.grey400,
                          size: 20.sp,
                        ),
                        onPressed: () => _removeSearchItem(query),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
