import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../logic/cart_notifier.dart';
import '../../data/models/cart_item_model.dart';
import '../../../../core/utils/pricing_calculator.dart';
import '../../../../core/utils/reference_generator.dart';
import '../widgets/checkout_header.dart';
import '../widgets/order_summary.dart';
import '../widgets/cart_item_card.dart';

// Class to hold project details for each service
class ServiceProjectDetails {
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> referenceLinkControllers = [];
  final List<Map<String, dynamic>> attachedFiles = [];
  bool isExpanded = true;

  void addReferenceLink() {
    referenceLinkControllers.add(TextEditingController());
  }

  void removeReferenceLink(int index) {
    referenceLinkControllers[index].dispose();
    referenceLinkControllers.removeAt(index);
  }

  void dispose() {
    descriptionController.dispose();
    for (var controller in referenceLinkControllers) {
      controller.dispose();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'description': descriptionController.text.trim(),
      'referenceLinks': referenceLinkControllers
          .map((c) => c.text.trim())
          .where((link) => link.isNotEmpty)
          .toList(),
      'attachedFiles': attachedFiles,
    };
  }

  bool get hasRequiredData {
    return descriptionController.text.trim().isNotEmpty;
  }
}

class ServiceSetupScreen extends ConsumerStatefulWidget {
  const ServiceSetupScreen({super.key});

  @override
  ConsumerState<ServiceSetupScreen> createState() => _ServiceSetupScreenState();
}

class _ServiceSetupScreenState extends ConsumerState<ServiceSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  // Map to store project details for each service by item ID
  final Map<String, ServiceProjectDetails> _serviceProjectDetails = {};

  @override
  void dispose() {
    // Dispose all controllers
    for (var details in _serviceProjectDetails.values) {
      details.dispose();
    }
    super.dispose();
  }

  void _toggleProjectDetails(String itemId) {
    setState(() {
      if (_serviceProjectDetails.containsKey(itemId)) {
        _serviceProjectDetails[itemId]!.isExpanded = !_serviceProjectDetails[itemId]!.isExpanded;
      } else {
        _serviceProjectDetails[itemId] = ServiceProjectDetails();
      }
    });
  }

  Future<void> _pickFiles(String itemId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          final details = _serviceProjectDetails[itemId];
          if (details != null) {
            for (var file in result.files) {
              if (file.size <= 10 * 1024 * 1024) {
                // Store file metadata
                // Note: In a real app, you would upload the file to get an ID
                // For now, we'll generate a temporary ID
                details.attachedFiles.add({
                  'id': DateTime.now().millisecondsSinceEpoch.toString() + file.name.hashCode.toString(),
                  'name': file.name,
                  'mimeType': _getMimeType(file.extension ?? ''),
                  'size': file.size,
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${file.name} is too large (max 10MB)')),
                );
              }
            }
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  List<CartItem> _filterServiceItems(List<CartItem> items) {
    return items.where((item) => item.type == 'service').toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final items = _filterServiceItems(cartState.items);
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
        'Service Setup',
        style: AppTexts.h3(color: Colors.white),
      ),
    );
  }

  Widget _buildContent(List<CartItem> items, PricingBreakdown breakdown) {
    // Generate service-specific reference
    final serviceReference = ReferenceGenerator.generateNumericReference('SRV');
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckoutHeader(
              transactionReference: serviceReference,
              checkoutType: 'service',
            ),
            SizedBox(height: 24.h),
            
            // Selected Services with individual project details
            Text('Selected Services', style: AppTexts.h4()),
            SizedBox(height: 16.h),
            ...items.map((item) => _buildServiceCardWithDetails(item)),
            
            SizedBox(height: 32.h),
            
            // Order Summary
            OrderSummary(breakdown: breakdown),
            
            SizedBox(height: 100.h), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCardWithDetails(CartItem item) {
    final hasDetails = _serviceProjectDetails.containsKey(item.id);
    final details = _serviceProjectDetails[item.id];
    final isExpanded = details?.isExpanded ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          // Service Card
          CartItemCard(item: item),
          
          // Add Project Details Button or Form
          if (!hasDetails || !isExpanded)
            _buildAddProjectDetailsButton(item.id)
          else
            _buildProjectDetailsForm(item.id, details!),
        ],
      ),
    );
  }

  Widget _buildAddProjectDetailsButton(String itemId) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _toggleProjectDetails(itemId),
          icon: Icon(Icons.add_circle_outline, size: 20.sp),
          label: Text('Add Project Details'),
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

  Widget _buildProjectDetailsForm(String itemId, ServiceProjectDetails details) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
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
                      Icons.description_outlined,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text('Project Details', style: AppTexts.h4()),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.grey600, size: 20.sp),
                onPressed: () => _toggleProjectDetails(itemId),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // Description Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Description', style: AppTexts.bodyMedium(color: AppColors.grey900)),
                  SizedBox(width: 4.w),
                  Text('*', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                ],
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: details.descriptionController,
                maxLines: 5,
                style: AppTexts.bodyMedium(),
                decoration: InputDecoration(
                  hintText: 'Describe your project requirements, goals, and expectations...',
                  hintStyle: AppTexts.bodySmall(color: AppColors.grey500),
                  filled: true,
                  fillColor: AppColors.grey50,
                  contentPadding: EdgeInsets.all(16.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (details.isExpanded && (value == null || value.trim().isEmpty)) {
                    return 'Please describe your project';
                  }
                  return null;
                },
              ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Reference Links Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reference Links', style: AppTexts.bodyMedium(color: AppColors.grey900)),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        details.addReferenceLink();
                      });
                    },
                    icon: Icon(Icons.add_circle_outline, size: 18.sp, color: AppColors.primaryColor),
                    label: Text('Add Link', style: AppTexts.labelSmall(color: AppColors.primaryColor)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              
              if (details.referenceLinkControllers.isEmpty)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.link_off, color: AppColors.grey400, size: 20.sp),
                      SizedBox(width: 12.w),
                      Text(
                        'No reference links added yet',
                        style: AppTexts.bodySmall(color: AppColors.grey500),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(details.referenceLinkControllers.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: details.referenceLinkControllers[index],
                            style: AppTexts.bodySmall(),
                            decoration: InputDecoration(
                              hintText: 'https://example.com',
                              hintStyle: AppTexts.bodySmall(color: AppColors.grey400),
                              prefixIcon: Icon(Icons.link, size: 18.sp, color: AppColors.primaryColor),
                              filled: true,
                              fillColor: AppColors.grey50,
                              contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: AppColors.grey300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: AppColors.grey300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red, size: 20.sp),
                            onPressed: () {
                              setState(() {
                                details.removeReferenceLink(index);
                              });
                            },
                            padding: EdgeInsets.all(8.w),
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Attach Files Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attach Files', style: AppTexts.bodyMedium(color: AppColors.grey900)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _pickFiles(itemId),
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
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Click to upload files',
                        style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'PDF, DOC, DOCX, JPG, PNG (Max 10MB each)',
                        style: AppTexts.labelSmall(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Show attached files
              if (details.attachedFiles.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
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
                          Icon(Icons.attach_file, size: 16.sp, color: AppColors.grey700),
                          SizedBox(width: 6.w),
                          Text(
                            '${details.attachedFiles.length} file(s) attached',
                            style: AppTexts.labelSmall(color: AppColors.grey700),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ...List.generate(details.attachedFiles.length, (index) {
                        final file = details.attachedFiles[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 6.h),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.insert_drive_file, color: AppColors.primaryColor, size: 18.sp),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  file['name'] ?? '',
                                  style: AppTexts.bodySmall(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    details.attachedFiles.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Icon(Icons.close, color: Colors.red, size: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80.sp, color: AppColors.grey400),
            SizedBox(height: 24.h),
            Text(
              'No Services Selected',
              style: AppTexts.h3(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Add services to your cart to continue',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => context.go('/services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Browse Services',
                style: AppTexts.buttonMedium(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
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
          onPressed: _handleContinueToPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Continue to Payment',
            style: AppTexts.buttonMedium(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _handleContinueToPayment() {
    // Validate all expanded project details forms
    if (_formKey.currentState?.validate() ?? false) {
      final cartState = ref.read(cartProvider);
      final items = _filterServiceItems(cartState.items);
      
      // Update cart items with project details
      for (var item in items) {
        final details = _serviceProjectDetails[item.id];
        if (details != null && details.isExpanded) {
          // Update the cart item with project details in metadata
          ref.read(cartProvider.notifier).updateItemMetadata(
            item.id,
            {
              ...item.metadata ?? {},
              'projectDetails': details.toJson(),
            },
          );
        }
      }
      
      // Navigate to checkout with service type
      context.push('/checkout?type=service');
    }
  }
}
