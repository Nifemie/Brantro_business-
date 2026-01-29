import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/widgets/skeleton_loading.dart';

class CategoryProfileList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final bool isLoading;
  final String? errorMessage;
  final String emptyMessage;
  final int maxItems;

  const CategoryProfileList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.errorMessage,
    this.emptyMessage = 'No profiles available',
    this.maxItems = 10,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        itemBuilder: (context, index) => SkeletonListItem(),
      );
    }

    if (errorMessage != null && items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            errorMessage!,
            style: AppTexts.bodyMedium(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            emptyMessage,
            style: AppTexts.bodyMedium(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final displayItems = items.length > maxItems ? items.take(maxItems).toList() : items;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: displayItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) => itemBuilder(context, displayItems[index]),
    );
  }
}
