import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/ad_slot_model.dart';
import '../../logic/ad_slot_details_notifier.dart';

class AdSlotDetailsScreen extends ConsumerStatefulWidget {
  final String adSlotId;
  final AdSlot? initialData;
  final bool hideBooking;

  const AdSlotDetailsScreen({
    super.key,
    required this.adSlotId,
    this.initialData,
    this.hideBooking = false,
  });

  @override
  ConsumerState<AdSlotDetailsScreen> createState() => _AdSlotDetailsScreenState();
}

class _AdSlotDetailsScreenState extends ConsumerState<AdSlotDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch data when screen initializes
    Future.microtask(() {
      ref.read(adSlotDetailsProvider(widget.adSlotId).notifier)
         .fetchAdSlotDetails(widget.adSlotId, initialData: widget.initialData);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getBadgeText(String partnerType) {
    if (partnerType.isEmpty) return 'Ad Slot';
    // Capitalize first letter and append "Slot" if needed
    final formattedType = partnerType[0].toUpperCase() + partnerType.substring(1);
    if (formattedType.toLowerCase().contains('slot')) {
      return formattedType;
    }
    return '$formattedType Slot';
  }

  Color _getBadgeColor(String partnerType) {
    switch (partnerType.toLowerCase()) {
      case 'influencer':
        return Colors.purple;
      case 'billboard':
        return Colors.blue;
      case 'screen':
      case 'digital screen':
        return Colors.cyan;
      case 'tv':
      case 'tv station':
        return Colors.red;
      case 'radio':
      case 'radio station':
        return Colors.orange;
      case 'producer':
        return Colors.green;
      case 'artist':
        return Colors.pink;
      default:
        return AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adSlotDetailsProvider(widget.adSlotId));
    final adSlot = state.singleData;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Ad Slot Details',
          style: AppTexts.h4(color: AppColors.textPrimary),
        ),
      ),
      body: state.isInitialLoading && adSlot == null
          ? _buildLoadingState()
          : state.message != null && adSlot == null
              ? _buildErrorState(state.message!)
              : adSlot != null 
                  ? _buildContent(adSlot)
                  : _buildLoadingState(),
    );
  }

  Widget _buildLoadingState() {
     return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(message, style: AppTexts.h4(), textAlign: TextAlign.center),
          SizedBox(height: 16.h),
           ElevatedButton(
            onPressed: () {
               ref.read(adSlotDetailsProvider(widget.adSlotId).notifier)
                  .fetchAdSlotDetails(widget.adSlotId);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AdSlot adSlot) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage(),
          _buildTitleSection(adSlot),
          _buildDescription(adSlot),
          _buildKeyDetails(adSlot),
          _buildPriceSection(adSlot),
          _buildQuantitySelector(),
          _buildActionButtons(),
          _buildWhatsIncluded(adSlot),
          _buildCoverage(adSlot),
          _buildPartnerInfo(adSlot),
          _buildTabs(),
          _buildTabContent(adSlot),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.campaign,
          size: 80.sp,
          color: AppColors.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildTitleSection(AdSlot adSlot) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            adSlot.title,
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getBadgeColor(adSlot.partnerType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _getBadgeText(adSlot.partnerType),
                  style: AppTexts.bodySmall(
                    color: _getBadgeColor(adSlot.partnerType),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 16.sp,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'Trusted Partner',
                style: AppTexts.bodyMedium(color: AppColors.grey600),
              ),
              SizedBox(width: 4.w),
              Text(
                '(${adSlot.sellerName})',
                style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Slot ID: ${adSlot.id}',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(AdSlot adSlot) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Text(
        adSlot.description,
        style: AppTexts.bodyMedium(color: AppColors.grey700),
      ),
    );
  }

  Widget _buildKeyDetails(AdSlot adSlot) {
    final details = [
      {'label': 'Audience', 'value': adSlot.audienceSize},
      {'label': 'Duration', 'value': adSlot.duration},
      {'label': 'Revisions', 'value': adSlot.maxRevisions.toString()},
      {'label': 'Location', 'value': adSlot.location},
      {
        'label': 'Platform',
        'value': adSlot.primaryPlatform != null
            ? '${adSlot.primaryPlatform!.name} (${adSlot.primaryPlatform!.handle})'
            : adSlot.partnerType
      },
      {'label': 'Content', 'value': adSlot.contentTypes.join(' + ')},
    ];

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...details.map((detail) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 6.sp, color: AppColors.primaryColor),
                    SizedBox(width: 8.w),
                    Text(
                      '${detail['label']}: ',
                      style: AppTexts.bodyMedium(color: AppColors.grey600),
                    ),
                    Expanded(
                      child: Text(
                        detail['value'] as String,
                        style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPriceSection(AdSlot adSlot) {
    // Hide the entire price section if hideBooking is true
    if (widget.hideBooking) {
      return SizedBox.shrink();
    }
    
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            adSlot.formattedPrice,
            style: AppTexts.h2(color: AppColors.textPrimary),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Handle book now
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('Book Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity:',
            style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() => _quantity--);
                  }
                },
                icon: Icon(Icons.remove_circle_outline),
                color: AppColors.primaryColor,
              ),
              SizedBox(
                width: 40.w,
                child: Text(
                  _quantity.toString(),
                  textAlign: TextAlign.center,
                  style: AppTexts.h4(color: AppColors.textPrimary),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() => _quantity++);
                },
                icon: Icon(Icons.add_circle_outline),
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Handle share
              },
              icon: Icon(Icons.share, size: 18.sp),
              label: Text('Share'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(color: AppColors.primaryColor),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          if (!widget.hideBooking) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Handle book
                },
                icon: Icon(Icons.shopping_cart, size: 18.sp),
                label: Text('Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ],
          SizedBox(width: 12.w),
          IconButton(
            onPressed: () {
              // TODO: Handle favorite
            },
            icon: Icon(Icons.favorite_border),
            color: AppColors.primaryColor,
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: () {
              // TODO: Handle share
            },
            icon: Icon(Icons.share),
            color: AppColors.primaryColor,
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsIncluded(AdSlot adSlot) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s Included',
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
          SizedBox(height: 12.h),
          ...adSlot.features.map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 16.sp, color: Colors.green),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTexts.bodyMedium(color: AppColors.grey700),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCoverage(AdSlot adSlot) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coverage',
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            adSlot.coverageAreas.join(', '),
            style: AppTexts.bodyMedium(color: AppColors.grey700),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerInfo(AdSlot adSlot) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Partner',
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.person, size: 16.sp, color: AppColors.primaryColor),
              SizedBox(width: 8.w),
              Text(
                adSlot.sellerName,
                style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (adSlot.user?['emailAddress'] != null) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.email, size: 16.sp, color: AppColors.primaryColor),
                SizedBox(width: 8.w),
                Text(
                  adSlot.user!['emailAddress'],
                  style: AppTexts.bodyMedium(color: AppColors.grey700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.grey600,
        indicatorColor: AppColors.primaryColor,
        tabs: [
          Tab(text: 'Features'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildTabContent(AdSlot adSlot) {
    return Container(
      height: 300.h, // Fixed height for tab content
      color: Colors.white,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildFeaturesTab(adSlot),
          _buildReviewsTab(),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab(AdSlot adSlot) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
          SizedBox(height: 12.h),
          Text(
            adSlot.description,
            style: AppTexts.bodyMedium(color: AppColors.grey700),
          ),
          SizedBox(height: 16.h),
          Text(
            'Key Highlight:',
             style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          ...adSlot.features.take(3).map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(fontSize: 16.sp)),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTexts.bodyMedium(color: AppColors.grey700),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined, size: 48.sp, color: AppColors.grey400),
            SizedBox(height: 12.h),
            Text(
              'No reviews yet',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}
