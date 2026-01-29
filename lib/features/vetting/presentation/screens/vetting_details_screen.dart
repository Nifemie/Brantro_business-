import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/vetting_model.dart';
import '../../logic/vetting_details_notifier.dart';

class VettingDetailsScreen extends ConsumerStatefulWidget {
  final String vettingId;
  final VettingOptionModel? initialData;

  const VettingDetailsScreen({
    super.key,
    required this.vettingId,
    this.initialData,
  });

  @override
  ConsumerState<VettingDetailsScreen> createState() => _VettingDetailsScreenState();
}

class _VettingDetailsScreenState extends ConsumerState<VettingDetailsScreen> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(vettingDetailsProvider(widget.vettingId).notifier)
         .fetchVettingDetails(widget.vettingId, initialData: widget.initialData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vettingDetailsProvider(widget.vettingId));
    final vetting = state.singleData;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Vetting Package',
          style: AppTexts.h4(color: AppColors.textPrimary),
        ),
      ),
      body: state.isInitialLoading && vetting == null
          ? _buildLoadingState()
          : state.message != null && vetting == null
              ? _buildErrorState(state.message!)
              : vetting != null 
                  ? _buildContent(vetting)
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
               ref.read(vettingDetailsProvider(widget.vettingId).notifier)
                  .fetchVettingDetails(widget.vettingId);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(VettingOptionModel vetting) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _buildHeaderCard(vetting),
          SizedBox(height: 16.h),

          // Description Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description', style: AppTexts.h4()),
                SizedBox(height: 8.h),
                Text(
                  vetting.description,
                  style: AppTexts.bodyMedium(color: AppColors.grey700),
                ),
                if (vetting.note != null && vetting.note!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.info.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: AppColors.info, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            vetting.note!,
                            style: AppTexts.bodySmall(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(height: 16.h),

          // Quantity Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity', style: AppTexts.h4()),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      icon: Icon(Icons.remove_circle_outline, color: AppColors.primaryColor),
                    ),
                    SizedBox(
                      width: 40.w,
                      child: Text(
                        '$_quantity',
                        textAlign: TextAlign.center,
                        style: AppTexts.h4(),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement checkout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Proceed to Checkout',
                    style: AppTexts.buttonLarge(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(VettingOptionModel vetting) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vetting.title,
                  style: AppTexts.h3(color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  vetting.durationDisplay,
                  style: AppTexts.bodySmall(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            vetting.formattedPrice,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Per application',
            style: AppTexts.bodySmall(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
