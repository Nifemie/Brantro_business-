import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/transaction_model.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../controllers/re_useable/app_color.dart';

class TransactionReceiptScreen extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionReceiptScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionReceiptScreen> createState() => _TransactionReceiptScreenState();
}

class _TransactionReceiptScreenState extends State<TransactionReceiptScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isProcessing = false;

  Future<void> _shareReceiptAsImage() async {
    setState(() => _isProcessing = true);
    try {
      // Capture the screenshot
      final imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 10),
        pixelRatio: 2.0,
      );

      if (imageBytes != null) {
        // Save to temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/receipt_${widget.transaction.reference}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        // Share the image
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Transaction Receipt - ${widget.transaction.reference}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share receipt: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(widget.transaction.createdAt);
    final isCredit = widget.transaction.isCredit;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E2329) : const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2F35) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'RECEIPT',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              children: [
                // The widget to capture
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    color: isDark ? const Color(0xFF1E2329) : const Color(0xFFF8F9FA),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status Icon and Amount
                        Center(
                          child: Container(
                            width: 64.w,
                            height: 64.w,
                            decoration: BoxDecoration(
                              color: isCredit
                                  ? AppColors.success.withValues(alpha: isDark ? 0.2 : 0.1)
                                  : AppColors.error.withValues(alpha: isDark ? 0.2 : 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isCredit ? AppColors.success : AppColors.error,
                                size: 32.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Transaction Successful',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '${isCredit ? "+" : "-"} ₦${NumberFormat('#,##0.00').format(widget.transaction.amount)}',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            color: isCredit ? AppColors.success : AppColors.error,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Receipt Card
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2F35) : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.05),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildReceiptRow(
                                'Transaction ID',
                                widget.transaction.reference,
                                isDark,
                                copyable: true,
                              ),
                              _buildDivider(isDark),
                              _buildReceiptRow('Date & Time', formattedDate, isDark),
                              _buildDivider(isDark),
                              _buildReceiptRow('Type', widget.transaction.type, isDark),
                              _buildDivider(isDark),
                              _buildReceiptRow('Source', widget.transaction.source, isDark),
                              if (widget.transaction.description.isNotEmpty) ...[
                                _buildDivider(isDark),
                                _buildReceiptRow('Narration', widget.transaction.description, isDark),
                              ],
                              _buildDivider(isDark),
                              _buildReceiptRow(
                                'Balance Before',
                                '₦${NumberFormat('#,##0.00').format(widget.transaction.balanceBefore)}',
                                isDark,
                              ),
                              _buildDivider(isDark),
                              _buildReceiptRow(
                                'Balance After',
                                '₦${NumberFormat('#,##0.00').format(widget.transaction.balanceAfter)}',
                                isDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 32.h),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share Image',
                        isDark: isDark,
                        onTap: _isProcessing ? () {} : _shareReceiptAsImage,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.download_outlined,
                        label: 'Download',
                        isDark: isDark,
                        isPrimary: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloading coming soon...')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, bool isDark, {bool copyable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (copyable) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.copy,
                    size: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primaryColor
              : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(12.r),
          border: isPrimary
              ? null
              : Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
