import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../logic/cart_notifier.dart';
import '../../data/models/cart_item_model.dart';
import '../../../../core/utils/pricing_calculator.dart';
import '../../../../core/utils/reference_generator.dart';
import '../widgets/checkout_header.dart';
import '../widgets/cart_item_card.dart';

// Class to hold campaign creatives for each campaign
class CampaignCreatives {
  final List<Map<String, dynamic>> creativeFiles = [];
  bool isExpanded = true;

  void addCreative(Map<String, dynamic> fileData) {
    creativeFiles.add(fileData);
  }

  void removeCreative(int index) {
    creativeFiles.removeAt(index);
  }

  bool get hasCreatives => creativeFiles.isNotEmpty;
  int get creativeCount => creativeFiles.length;

  Map<String, dynamic> toJson() {
    return {
      'creativeFiles': creativeFiles,
    };
  }
}

class CampaignSetupScreen extends ConsumerStatefulWidget {
  const CampaignSetupScreen({super.key});

  @override
  ConsumerState<CampaignSetupScreen> createState() => _CampaignSetupScreenState();
}

class _CampaignSetupScreenState extends ConsumerState<CampaignSetupScreen> {
  // Map to store creatives for each campaign by item ID
  final Map<String, CampaignCreatives> _campaignCreatives = {};
  static const String _cacheKey = 'campaign_setup_creatives';

  @override
  void initState() {
    super.initState();
    _loadCachedCreatives();
  }

  @override
  void dispose() {
    _saveCachedCreatives();
    super.dispose();
  }

  Future<void> _loadCachedCreatives() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      
      if (cachedData != null) {
        final Map<String, dynamic> decoded = json.decode(cachedData);
        
        // Get current cart items
        final cartState = ref.read(cartProvider);
        final currentItems = _filterCampaignItems(cartState.items);
        final currentItemIds = currentItems.map((item) => item.id).toSet();
        
        setState(() {
          decoded.forEach((itemId, creativesData) {
            // Only load cache for items that are currently in the cart
            if (currentItemIds.contains(itemId)) {
              final creatives = CampaignCreatives();
              final files = creativesData['creativeFiles'] as List<dynamic>?;
              if (files != null) {
                for (var file in files) {
                  creatives.addCreative(Map<String, dynamic>.from(file));
                }
              }
              creatives.isExpanded = creativesData['isExpanded'] ?? false;
              _campaignCreatives[itemId] = creatives;
            }
          });
        });
      }
    } catch (e) {
      // Silently handle cache loading errors
    }
  }

  Future<void> _saveCachedCreatives() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> dataToCache = {};
      
      _campaignCreatives.forEach((itemId, creatives) {
        dataToCache[itemId] = {
          'creativeFiles': creatives.creativeFiles,
          'isExpanded': creatives.isExpanded,
        };
      });
      
      await prefs.setString(_cacheKey, json.encode(dataToCache));
    } catch (e) {
      // Silently handle cache saving errors
    }
  }

  void _clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (e) {
      // Silently handle cache clearing errors
    }
  }

  void _toggleCreativesSection(String itemId) {
    setState(() {
      if (_campaignCreatives.containsKey(itemId)) {
        _campaignCreatives[itemId]!.isExpanded = !_campaignCreatives[itemId]!.isExpanded;
      } else {
        _campaignCreatives[itemId] = CampaignCreatives();
      }
    });
  }

  Future<void> _pickCreativeFiles(String itemId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          // Images
          'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp',
          // Videos
          'mp4', 'mov', 'avi', 'mkv', 'webm',
          // Documents
          'pdf', 'doc', 'docx',
          // Other
          'zip', 'rar'
        ],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          final creatives = _campaignCreatives[itemId];
          if (creatives != null) {
            for (var file in result.files) {
              if (file.size <= 50 * 1024 * 1024) { // 50MB limit
                // Store file metadata
                creatives.addCreative({
                  'id': DateTime.now().millisecondsSinceEpoch.toString() + file.name.hashCode.toString(),
                  'name': file.name,
                  'mimeType': _getMimeType(file.extension ?? ''),
                  'size': file.size,
                  'type': _getFileType(file.extension ?? ''),
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${file.name} is too large (max 50MB)')),
                );
              }
            }
          }
        });
        // Save to cache after adding files
        _saveCachedCreatives();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      // Images
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      // Videos
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case 'webm':
        return 'video/webm';
      // Documents
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      // Archives
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      default:
        return 'application/octet-stream';
    }
  }

  String _getFileType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'bmp':
        return 'image';
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
      case 'webm':
        return 'video';
      case 'pdf':
      case 'doc':
      case 'docx':
        return 'document';
      case 'zip':
      case 'rar':
        return 'archive';
      default:
        return 'file';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  List<CartItem> _filterCampaignItems(List<CartItem> items) {
    return items.where((item) => item.type == 'adslot' || item.type == 'campaign').toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final items = _filterCampaignItems(cartState.items);
    final breakdown = PricingCalculator.getBreakdown(
      items.fold(0.0, (sum, item) => sum + item.priceValue),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: items.isEmpty ? _buildEmptyState() : _buildContent(items, breakdown),
      bottomNavigationBar: items.isNotEmpty ? _buildBottomBar() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF003D82),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Campaign Setup',
        style: AppTexts.h3(color: Colors.white),
      ),
    );
  }

  Widget _buildContent(List<CartItem> items, PricingBreakdown breakdown) {
    final campaignReference = ReferenceGenerator.generateNumericReference('CMP');
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckoutHeader(
            transactionReference: campaignReference,
            checkoutType: 'campaign',
          ),
          SizedBox(height: 24.h),
          
          // Selected Campaigns with creative assignment
          Text('Selected Campaigns', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          ...items.map((item) => _buildCampaignCardWithCreatives(item)),
          
          SizedBox(height: 32.h),
          
          // Order Summary with Progress
          _buildOrderSummaryWithProgress(breakdown, items),
          
          SizedBox(height: 100.h), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildCampaignCardWithCreatives(CartItem item) {
    final hasCreatives = _campaignCreatives.containsKey(item.id);
    final creatives = _campaignCreatives[item.id];
    final isExpanded = creatives?.isExpanded ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          // Campaign Card
          CartItemCard(item: item),
          
          // Add Creatives Button or Section
          if (!hasCreatives || !isExpanded)
            _buildAddCreativesButton(item.id)
          else
            _buildCreativesSection(item.id, creatives!),
        ],
      ),
    );
  }

  Widget _buildAddCreativesButton(String itemId) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _toggleCreativesSection(itemId),
          icon: Icon(Icons.add_circle_outline, size: 20.sp),
          label: Text('Add Creatives'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreativesSection(String itemId, CampaignCreatives creatives) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text('Campaign Creatives', style: AppTexts.h4()),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.grey600, size: 20.sp),
                onPressed: () => _toggleCreativesSection(itemId),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // Upload Creatives Button
          GestureDetector(
            onTap: () => _pickCreativeFiles(itemId),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      color: AppColors.primaryColor,
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Upload Creatives from Device',
                    style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Images, Videos, PDFs, Documents (Max 50MB)',
                    style: AppTexts.labelSmall(color: AppColors.grey600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          if (creatives.hasCreatives) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        '${creatives.creativeCount} creative(s) uploaded',
                        style: AppTexts.bodyMedium(color: AppColors.grey900),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ...List.generate(creatives.creativeFiles.length, (index) {
                    final file = creatives.creativeFiles[index];
                    final isVideo = file['type'] == 'video';
                    final fileSize = _formatFileSize(file['size'] as int);
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: isVideo 
                                  ? Colors.purple.withOpacity(0.1)
                                  : AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              isVideo ? Icons.videocam : Icons.image,
                              color: isVideo ? Colors.purple : AppColors.primaryColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file['name'] ?? 'Creative ${index + 1}',
                                  style: AppTexts.bodyMedium(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: isVideo 
                                            ? Colors.purple.withOpacity(0.1)
                                            : AppColors.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Text(
                                        isVideo ? 'VIDEO' : 'IMAGE',
                                        style: AppTexts.labelSmall(
                                          color: isVideo ? Colors.purple : AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      fileSize,
                                      style: AppTexts.labelSmall(color: AppColors.grey500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                creatives.removeCreative(index);
                                // If no more creatives, collapse the section
                                if (!creatives.hasCreatives) {
                                  creatives.isExpanded = false;
                                }
                              });
                              // Save to cache after deleting
                              _saveCachedCreatives();
                            },
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Icon(Icons.delete_outline, color: Colors.red, size: 18.sp),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 8.h),
                  // Add More Creatives Button
                  GestureDetector(
                    onTap: () => _pickCreativeFiles(itemId),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Add More Creatives',
                            style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummaryWithProgress(PricingBreakdown breakdown, List<CartItem> items) {
    // Calculate progress
    int totalCampaigns = items.length;
    int campaignsWithCreatives = _campaignCreatives.values.where((c) => c.hasCreatives).length;
    double progress = totalCampaigns > 0 ? campaignsWithCreatives / totalCampaigns : 0.0;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          
          // Progress Bar Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Campaign Setup Progress',
                      style: AppTexts.bodyMedium(color: AppColors.grey900),
                    ),
                    Text(
                      '$campaignsWithCreatives/$totalCampaigns',
                      style: AppTexts.h4(color: AppColors.primaryColor),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.h,
                    backgroundColor: AppColors.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? Colors.green : AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  progress == 1.0
                      ? 'All campaigns have creatives assigned!'
                      : 'Add creatives to all campaigns to continue',
                  style: AppTexts.labelSmall(
                    color: progress == 1.0 ? Colors.green : AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20.h),
          Divider(color: AppColors.grey200),
          SizedBox(height: 16.h),
          
          // Price Breakdown
          _buildPriceRow('Subtotal', breakdown.formattedSubtotal),
          SizedBox(height: 12.h),
          _buildPriceRow('VAT (7.5%)', breakdown.formattedVAT),
          SizedBox(height: 12.h),
          _buildPriceRow('Service Charge', breakdown.formattedServiceCharge),
          SizedBox(height: 16.h),
          Divider(color: AppColors.grey200),
          SizedBox(height: 16.h),
          _buildPriceRow('Total', breakdown.formattedTotal, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTexts.h4()
              : AppTexts.bodyMedium(color: AppColors.grey700),
        ),
        Text(
          value,
          style: isTotal
              ? AppTexts.h3(color: AppColors.primaryColor)
              : AppTexts.bodyMedium(color: AppColors.grey900),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 80.sp, color: AppColors.grey400),
            SizedBox(height: 24.h),
            Text(
              'No Campaigns Selected',
              style: AppTexts.h3(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Add campaigns to your cart to continue',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Browse Campaigns',
                style: AppTexts.buttonMedium(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final cartState = ref.watch(cartProvider);
    final items = _filterCampaignItems(cartState.items);
    
    // Check if all campaigns have creatives
    bool allCampaignsHaveCreatives = items.every((item) {
      final creatives = _campaignCreatives[item.id];
      return creatives != null && creatives.hasCreatives;
    });

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: allCampaignsHaveCreatives ? _handleContinueToPayment : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            disabledBackgroundColor: AppColors.grey300,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            allCampaignsHaveCreatives
                ? 'Continue to Payment'
                : 'Add Creatives to Continue',
            style: AppTexts.buttonMedium(
              color: allCampaignsHaveCreatives ? Colors.white : AppColors.grey600,
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinueToPayment() {
    final cartState = ref.read(cartProvider);
    final items = _filterCampaignItems(cartState.items);
    
    // Update cart items with campaign creatives in metadata
    for (var item in items) {
      final creatives = _campaignCreatives[item.id];
      if (creatives != null && creatives.hasCreatives) {
        ref.read(cartProvider.notifier).updateItemMetadata(
          item.id,
          {
            ...item.metadata ?? {},
            'campaignCreatives': creatives.toJson(),
          },
        );
      }
    }
    
    // Clear cache after saving to cart
    _clearCache();
    
    // Navigate to checkout with campaign type
    context.push('/checkout?type=campaign');
  }
}
