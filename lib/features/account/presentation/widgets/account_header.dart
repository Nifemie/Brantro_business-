import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/widgets/search_bar_widget.dart';
import '../../../../controllers/re_useable/app_color.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.primaryColor,
      child: SafeArea(
        bottom: false,
        child: SearchBarWidget(
          hintText: 'Search on Brantro',
          readOnly: true,
          onTap: () {
            context.push('/search');
          },
        ),
      ),
    );
  }
}
