import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: AppTexts.h3(color: AppColors.textPrimary),
        ),
      ),
      body: ListView(
        children: [
          _buildNotificationItem(
            title: 'Order Completed',
            timestamp: '11 Sep 2019 08:40',
            message: 'Your order is completed',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Order Arrived',
            timestamp: '11 Sep 2019 08:39',
            message: 'Your order has arrived',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Flash Sale',
            timestamp: '10 Sep 2019 10:00',
            message:
                'Hi Robert Steven, Flash Sale is open in 10 minutes. Grab your favorite product on sale',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Order Sent',
            timestamp: '9 Sep 2019 14:12',
            message: 'Your order is being shipped by courier',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Ready to Pickup',
            timestamp: '9 Sep 2019 14:12',
            message: 'Your order is ready to be picked up by the courier',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Trending Product',
            timestamp: '10 Sep 2019 08:40',
            message:
                'Hi Robert Steven, there is a trending product for you, check it out now',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Order Processed',
            timestamp: '9 Sep 2019 12:15',
            message: 'Your order is being processed',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Payment Received',
            timestamp: '8 Sep 2019 10:30',
            message: 'Payment has been received',
          ),
          _buildDivider(),
          _buildNotificationItem(
            title: 'Waiting for Payment',
            timestamp: '8 Sep 2019 09:15',
            message: 'Please complete your payment',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String timestamp,
    required String message,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
          SizedBox(height: 4.h),
          // Timestamp
          Text(
            timestamp,
            style: AppTexts.bodySmall(color: AppColors.grey400),
          ),
          SizedBox(height: 8.h),
          // Message
          Text(
            message,
            style: AppTexts.bodyMedium(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.grey200,
      thickness: 1,
      height: 1,
    );
  }
}
