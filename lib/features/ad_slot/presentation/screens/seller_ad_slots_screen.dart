import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class SellerAdSlotsScreen extends StatefulWidget {
  final int userId;
  final String? sellerName;
  final String? sellerAvatar;
  final String sellerType; // e.g., 'Artist', 'Influencer', 'Billboard', 'Radio Station', etc.

  const SellerAdSlotsScreen({
    super.key,
    required this.userId,
    this.sellerName,
    this.sellerAvatar,
    this.sellerType = 'Artist', // Default to Artist
  });

  @override
  State<SellerAdSlotsScreen> createState() => _SellerAdSlotsScreenState();
}

class _SellerAdSlotsScreenState extends State<SellerAdSlotsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Filter states
  String? _selectedPlatform;
  String? _selectedContentType;
  RangeValues _priceRange = const RangeValues(0, 1000000);

  // Platform options
  final List<String> _platforms = [
    'All Platforms',
    'Instagram',
    'TikTok',
    'YouTube',
    'Facebook',
    'X (Twitter)',
    'Snapchat',
    'Music Video',
    'Live Concert',
    'Stage Show',
  ];

  // Content type options
  final List<String> _contentTypes = [
    'All Content Types',
    'Promo Video',
    'Brand Mention',
    'Endorsement Clip',
    'Instagram Post',
    'Instagram Story',
    'Instagram Reel',
    'TikTok Video',
    'YouTube Video',
    'Facebook Post',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search and filters
          _buildSearchAndFilters(),
          
          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      toolbarHeight: 80.h, // Increased app bar height
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
      ),
      title: Row(
        children: [
          // Seller avatar - bigger size
          CircleAvatar(
            radius: 28.r,
            backgroundImage: widget.sellerAvatar != null && widget.sellerAvatar!.isNotEmpty
                ? (widget.sellerAvatar!.startsWith('http')
                    ? NetworkImage(widget.sellerAvatar!)
                    : AssetImage(widget.sellerAvatar!)) as ImageProvider
                : null,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: (widget.sellerAvatar == null || widget.sellerAvatar!.isEmpty)
                ? Icon(Icons.person, color: Colors.white, size: 28.sp)
                : null,
          ),
          SizedBox(width: 12.w),
          
          // Seller info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (widget.sellerName != null && widget.sellerName!.isNotEmpty)
                      ? widget.sellerName!
                      : widget.sellerType,
                  style: AppTexts.h3(color: Colors.white)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Advertising Slots',
                  style: AppTexts.bodyMedium(color: Colors.white70), // Increased from bodySmall
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to artist profile details
          },
          icon: Icon(Icons.info_outline, color: Colors.white, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search ad slots...',
              prefixIcon: Icon(Icons.search, color: AppColors.grey600),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.grey600),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.grey300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.grey300),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          
          SizedBox(height: 12.h),
          
          // Filter dropdowns
          Row(
            children: [
              // Platform dropdown
              Expanded(
                child: _buildDropdown(
                  hint: 'Platform',
                  value: _selectedPlatform,
                  items: _platforms,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlatform = value;
                    });
                  },
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Content Type dropdown
              Expanded(
                child: _buildDropdown(
                  hint: 'Content Type',
                  value: _selectedContentType,
                  items: _contentTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedContentType = value;
                    });
                  },
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Clear filters button
              IconButton(
                onPressed: _clearFilters,
                icon: Icon(Icons.filter_alt_off, color: AppColors.primaryColor),
                tooltip: 'Clear Filters',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.grey600),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTexts.bodySmall(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildContent() {
    // TODO: Replace with actual data from state management
    final hasSlots = false;
    
    if (!hasSlots) {
      return _buildEmptyState();
    }
    
    // This will show ad slots when data is available
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Showing count
          Text(
            'Showing 0 slots',
            style: AppTexts.bodyMedium(color: AppColors.grey600),
          ),
          SizedBox(height: 16.h),
          
          // Grid view of ad slots
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: 0,
            itemBuilder: (context, index) {
              return Container(); // Placeholder for ad slot card
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty icon
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 64.sp,
                color: AppColors.grey400,
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Title
            Text(
              'No Ad Slots Available',
              style: AppTexts.h3(color: AppColors.textPrimary)
                  .copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 12.h),
            
            // Description
            Text(
              'This ${widget.sellerType.toLowerCase()} hasn\'t created any advertising slots yet.\nCheck back later or explore other ${widget.sellerType.toLowerCase()}s.',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 32.h),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clear filters button (if filters are active)
                if (_selectedPlatform != null || 
                    _selectedContentType != null || 
                    _searchController.text.isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: _clearFilters,
                    icon: Icon(Icons.filter_alt_off, size: 18.sp),
                    label: Text('Clear Filters'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                
                if (_selectedPlatform != null || 
                    _selectedContentType != null || 
                    _searchController.text.isNotEmpty)
                  SizedBox(width: 12.w),
                
                // Explore other sellers button
                ElevatedButton.icon(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(Icons.explore, size: 18.sp),
                  label: Text('Explore ${widget.sellerType}s'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedPlatform = null;
      _selectedContentType = null;
      _priceRange = const RangeValues(0, 1000000);
      _searchController.clear();
    });
  }
}
