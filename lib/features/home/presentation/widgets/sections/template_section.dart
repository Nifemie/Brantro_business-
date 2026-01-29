import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../template/presentation/widgets/template_card.dart';
import '../../../../template/presentation/widgets/template_added_sheet.dart';
import '../../../../template/logic/template_notifier.dart';

class TemplateSection extends ConsumerStatefulWidget {
  const TemplateSection({super.key});

  @override
  ConsumerState<TemplateSection> createState() => _TemplateSectionState();
}

class _TemplateSectionState extends ConsumerState<TemplateSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(templateProvider.notifier).fetchTemplates(page: 0, size: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final templateState = ref.watch(templateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Design Templates', style: AppTexts.h3()),
                  SizedBox(height: 4.h),
                  Text(
                    'Free and premium templates for your campaigns',
                    style: AppTexts.bodySmall(color: AppColors.grey600),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.push('/template');
                },
                child: Text(
                  'See All',
                  style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Content based on state
        if (templateState.isInitialLoading)
          _buildLoadingState()
        else if (templateState.message != null && !templateState.isDataAvailable)
          _buildErrorState(templateState.message!, ref)
        else if ((templateState.data ?? []).isEmpty)
          _buildEmptyState()
        else
          _buildTemplateList(templateState.data!),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 380.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: SkeletonCard(width: 280.w, height: 380.h),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, WidgetRef ref) {
    return Container(
      height: 380.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Failed to load templates', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(error, style: AppTexts.bodySmall(color: AppColors.grey600), textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref.read(templateProvider.notifier).fetchTemplates(page: 0, size: 5),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 380.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.design_services_outlined, size: 48.sp, color: AppColors.grey400),
            SizedBox(height: 16.h),
            Text('No templates available', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text('Check back later', style: AppTexts.bodySmall(color: AppColors.grey600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateList(List templates) {
    return SizedBox(
      height: 380.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: templates.length > 5 ? 5 : templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          
          return Container(
            width: 280.w,
            margin: EdgeInsets.only(right: 16.w),
            child: TemplateCard(
              imageUrl: template.thumbnail,
              badge: template.type,
              title: template.title,
              description: template.description,
              tags: template.tagsList,
              price: template.formattedPrice,
              originalPrice: template.formattedOriginalPrice,
              discount: template.formattedDiscount,
              buttonText: template.isFree ? 'Use Template' : 'Buy Now',
              isFree: template.isFree,
              onTap: () => _handleTemplateClick(context, template),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleTemplateClick(BuildContext context, dynamic template) async {
    // Navigate to template details screen
    context.push('/template-details/${template.id}', extra: template);
  }
}
