import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/order_model.dart';
import '../../../../core/network/api_client.dart';

class OrderCustomerCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const OrderCustomerCard({
    super.key,
    required this.order,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final userMap = order.metadata?['user'] ?? order.metadata?['creator'] ?? {};
    final alias = userMap['alias']?.toString();
    final avatarUrl = userMap['avatarUrl']?.toString();
    final country = userMap['country']?.toString();
    final state = userMap['state']?.toString();
    final city = userMap['city']?.toString();
    final address = userMap['address']?.toString();
    final createdAtStr = userMap['createdAt']?.toString();
    
    DateTime? joinedDate;
    if (createdAtStr != null) {
      joinedDate = DateTime.tryParse(createdAtStr);
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : AppColors.shadow.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          SizedBox(height: 24.h),
          _buildProfileHeader(avatarUrl, alias, joinedDate),
          SizedBox(height: 24.h),
          Divider(color: isDark ? Colors.white10 : Colors.grey[200]),
          SizedBox(height: 16.h),
          _buildContactGrid(),
          if (address != null || city != null || country != null) ...[
            SizedBox(height: 16.h),
            _buildLocationBox(city, state, country, address),
          ],
          SizedBox(height: 24.h),
          _buildContactButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.person_pin_rounded,
            size: 20.sp,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Customer Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(String? avatarUrl, String? alias, DateTime? joinedDate) {
    final fullAvatarUrl = (avatarUrl != null && avatarUrl.isNotEmpty) 
        ? '${ApiClient.fileBaseUrl}/$avatarUrl'
        : null;

    return Row(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor.withOpacity(0.1),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 2),
          ),
          child: ClipOval(
            child: fullAvatarUrl != null
                ? Image.network(
                    fullAvatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.person, color: AppColors.primaryColor, size: 30.sp),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor));
                    },
                  )
                : Icon(
                    Icons.person,
                    size: 30.sp,
                    color: AppColors.primaryColor,
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.customerName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              if (alias != null && alias.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  '@$alias',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (joinedDate != null) ...[
                SizedBox(height: 4.h),
                Text(
                  'Joined ${DateFormat('MMMM yyyy').format(joinedDate)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactGrid() {
    return Column(
      children: [
        _buildInfoRow(Icons.email_rounded, 'Email Address', order.customerEmail),
        SizedBox(height: 12.h),
        _buildInfoRow(Icons.phone_rounded, 'Phone Number', order.customerPhone),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.grey[50],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationBox(String? city, String? state, String? country, String? address) {
    final locationParts = [city, state, country].where((p) => p != null && p.isNotEmpty).toList();
    final locationString = locationParts.join(', ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16.sp, color: AppColors.primaryColor),
              SizedBox(width: 8.w),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (locationString.isNotEmpty)
            Text(
              locationString,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          if (address != null && address.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              address,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactButtons() {
    return Row(
      children: [
        if (order.customerEmail.isNotEmpty)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _launchEmail(order.customerEmail),
              icon: Icon(Icons.email_rounded, size: 18.sp, color: Colors.white),
              label: Text('Email', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        if (order.customerEmail.isNotEmpty && order.customerPhone.isNotEmpty)
          SizedBox(width: 12.w),
        if (order.customerPhone.isNotEmpty)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _launchPhone(order.customerPhone),
              icon: Icon(Icons.phone_rounded, size: 18.sp, color: AppColors.primaryColor),
              label: Text('Call', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryColor),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
