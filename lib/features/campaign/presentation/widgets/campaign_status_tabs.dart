import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class CampaignStatusTabs extends StatelessWidget {
  final TabController tabController;
  final bool isSeller;
  final bool isSuperAdmin;

  const CampaignStatusTabs({
    super.key,
    required this.tabController,
    required this.isSeller,
    this.isSuperAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 3,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.grey600,
        labelStyle: AppTexts.labelMedium().copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTexts.labelMedium(),
        tabs: isSuperAdmin 
            ? _buildSuperAdminTabs() 
            : isSeller 
                ? _buildSellerTabs() 
                : _buildBuyerTabs(),
      ),
    );
  }

  List<Widget> _buildBuyerTabs() {
    return [
      _buildTab('All', Icons.list_alt),
      _buildTab('Requested', Icons.pending_outlined),
      _buildTab('Accepted', Icons.check_circle_outline),
      _buildTab('In Progress', Icons.hourglass_empty),
      _buildTab('Completed', Icons.done_all),
    ];
  }

  List<Widget> _buildSellerTabs() {
    return [
      _buildTab('Requests', Icons.inbox_outlined),
      _buildTab('Accepted', Icons.check_circle_outline),
      _buildTab('In Progress', Icons.hourglass_empty),
      _buildTab('Completed', Icons.done_all),
    ];
  }

  List<Widget> _buildSuperAdminTabs() {
    return [
      // Buyer tabs
      _buildTab('All', Icons.list_alt),
      _buildTab('Requested', Icons.pending_outlined),
      _buildTab('Accepted', Icons.check_circle_outline),
      _buildTab('In Progress', Icons.hourglass_empty),
      _buildTab('Completed', Icons.done_all),
      // Seller tabs
      _buildTab('Requests', Icons.inbox_outlined),
      _buildTab('S-Accepted', Icons.check_circle_outline),
      _buildTab('S-Progress', Icons.hourglass_empty),
      _buildTab('S-Completed', Icons.done_all),
    ];
  }

  Widget _buildTab(String label, IconData icon) {
    return Tab(
      height: 48.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp),
          SizedBox(width: 6.w),
          Text(label),
        ],
      ),
    );
  }
}
