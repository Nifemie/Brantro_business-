import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../logic/cart_notifier.dart';
import '../../logic/checkout_notifier.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/template_order_request.dart';
import '../../data/models/creative_order_request.dart';
import '../../data/models/service_order_request.dart';
import '../../data/models/campaign_order_request.dart';
import '../../../wallet/logic/wallet_notifier.dart';
import '../../../payment/logic/payment_notifier.dart';
import '../../../payment/utils/payment_helper.dart';
import '../../../auth/logic/auth_notifiers.dart';
import '../../../../core/utils/pricing_calculator.dart';
import '../../../../core/utils/reference_generator.dart';
import '../../../../core/data/data_state.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/checkout_header.dart';
import '../widgets/order_summary.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/order_success_modal.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _paymentMethod = 'wallet';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(walletProvider.notifier).fetchWallet());
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final walletState = ref.watch(walletProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final checkoutType = GoRouterState.of(context).uri.queryParameters['type'] ?? 'template';
    
    final items = _filterItemsByType(cartState.items, checkoutType);
    final breakdown = PricingCalculator.getBreakdown(
      items.fold(0.0, (sum, item) => sum + item.priceValue),
    );
    
    // Generate reference specific to checkout type
    final checkoutReference = _generateReferenceForType(checkoutType);
    
    // Show loading if wallet is still being fetched
    if (walletState.isLoading && walletState.wallet == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(checkoutType),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }
    
    final walletBalance = double.tryParse(walletState.wallet?.balance ?? '0') ?? 0.0;
    final isWalletSufficient = walletBalance >= breakdown.total;

    // Listen to checkout state changes
    ref.listen<CheckoutState>(checkoutProvider, (previous, next) {
      if (next.message != null && !next.isSuccess) {
        // Only show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      if (next.isSuccess) {
        // Clear only the items that were checked out
        ref.read(cartProvider.notifier).clearItemsByType(checkoutType);
        
        // Show success modal
        OrderSuccessModal.show(
          context,
          orderType: checkoutType,
          orderId: checkoutReference,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(checkoutType),
      body: items.isEmpty ? _buildEmptyState() : _buildContent(items, breakdown, walletBalance, isWalletSufficient, checkoutType, checkoutReference),
      bottomNavigationBar: items.isNotEmpty 
          ? _buildBottomBar(breakdown, isWalletSufficient) 
          : null,
    );
  }

  AppBar _buildAppBar(String checkoutType) {
    return AppBar(
      backgroundColor: const Color(0xFF003D82),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        _getTitle(checkoutType),
        style: AppTexts.h3(color: Colors.white),
      ),
    );
  }

  Widget _buildContent(
    List<CartItem> items,
    PricingBreakdown breakdown,
    double walletBalance,
    bool isWalletSufficient,
    String checkoutType,
    String checkoutReference,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckoutHeader(
            transactionReference: checkoutReference,
            checkoutType: checkoutType,
          ),
          SizedBox(height: 24.h),
          
          // Only show selected items for template and creative checkouts
          // Hide for service and campaign since they have setup screens
          if (checkoutType != 'service' && checkoutType != 'campaign') ...[
            Text('Selected Items', style: AppTexts.h4()),
            SizedBox(height: 16.h),
            ...items.map((item) => CartItemCard(item: item)),
            SizedBox(height: 32.h),
          ],
          
          PaymentMethodSection(
            selectedPaymentMethod: _paymentMethod,
            walletBalance: walletBalance,
            isWalletSufficient: isWalletSufficient,
            onPaymentMethodChanged: (value) => setState(() => _paymentMethod = value),
          ),
          SizedBox(height: 24.h),
          OrderSummary(breakdown: breakdown),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildBottomBar(PricingBreakdown breakdown, bool isWalletSufficient) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_paymentMethod == 'wallet' && !isWalletSufficient)
              _buildInsufficientBalanceWarning(),
            FullWidthButton(
              text: 'Confirm & Pay ${breakdown.formattedTotal}',
              isEnabled: !(_paymentMethod == 'wallet' && !isWalletSufficient),
              isLoading: ref.watch(checkoutProvider).isLoading,
              onPressed: () => _handlePayment(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsufficientBalanceWarning() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Insufficient wallet balance. Please top up or use another payment method.',
                style: AppTexts.bodySmall(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final checkoutType = GoRouterState.of(context).uri.queryParameters['type'] ?? 'template';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text('Your cart is empty', style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            'Add items to your cart to continue',
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _navigateToListingScreen(context, checkoutType),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
            ),
            child: Text(_getBrowseButtonText(checkoutType)),
          ),
        ],
      ),
    );
  }

  String _getBrowseButtonText(String checkoutType) {
    switch (checkoutType) {
      case 'service':
        return 'Browse Services';
      case 'creative':
        return 'Browse Creatives';
      case 'campaign':
        return 'Browse Ad Slots';
      default:
        return 'Browse Templates';
    }
  }

  void _navigateToListingScreen(BuildContext context, String checkoutType) {
    switch (checkoutType) {
      case 'service':
        context.push('/services');
        break;
      case 'creative':
        context.push('/creatives');
        break;
      case 'campaign':
        context.push('/explore?category=Ad Slots');
        break;
      default:
        context.push('/templates');
    }
  }

  List<CartItem> _filterItemsByType(List<CartItem> items, String checkoutType) {
    switch (checkoutType) {
      case 'campaign':
        return items.where((item) => item.type == 'adslot' || item.type == 'campaign').toList();
      case 'service':
        return items.where((item) => item.type == 'service').toList();
      case 'creative':
        return items.where((item) => item.type == 'creative').toList();
      default:
        return items.where((item) => item.type == 'template').toList();
    }
  }

  String _getTitle(String checkoutType) {
    switch (checkoutType) {
      case 'campaign':
        return 'Campaign Checkout';
      case 'service':
        return 'Service Checkout';
      case 'creative':
        return 'Creative Checkout';
      default:
        return 'Template Checkout';
    }
  }

  String _generateReferenceForType(String type) {
    switch (type) {
      case 'template':
        return ReferenceGenerator.generateNumericReference('TPL');
      case 'service':
        return ReferenceGenerator.generateNumericReference('SRV');
      case 'creative':
        return ReferenceGenerator.generateNumericReference('CRTV');
      case 'campaign':
        return ReferenceGenerator.generateNumericReference('CMP');
      default:
        return ReferenceGenerator.generateNumericReference('ORD');
    }
  }

  void _handlePayment(BuildContext context) {
    final cartState = ref.read(cartProvider);
    final checkoutType = GoRouterState.of(context).uri.queryParameters['type'] ?? 'template';
    final items = _filterItemsByType(cartState.items, checkoutType);
    
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    final breakdown = PricingCalculator.getBreakdown(
      items.fold(0.0, (sum, item) => sum + item.priceValue),
    );

    // If Paystack payment, handle with SDK
    if (_paymentMethod == 'paystack') {
      _handlePaystackPayment(context, checkoutType, items, breakdown);
      return;
    }

    // Otherwise, handle wallet payment
    if (checkoutType == 'creative') {
      // Build creative order request
      final orderItems = items.map((item) {
        return CreativeOrderItem(
          id: int.tryParse(item.id) ?? 0,
          reference: ReferenceGenerator.generateReference(),
        );
      }).toList();

      final request = CreativeOrderRequest(
        items: orderItems,
        method: _paymentMethod.toUpperCase(),
        currency: 'NGN',
        amount: breakdown.total,
        paymentRef: cartState.reference ?? '',
        remark: 'Purchase of creatives',
      );

      // Submit creative order
      ref.read(checkoutProvider.notifier).submitCreativeOrder(request);
    } else if (checkoutType == 'service') {
      // Build service order request
      final orderItems = items.map((item) {
        // Extract project details from metadata if available
        final metadata = item.metadata ?? {};
        final projectDetails = metadata['projectDetails'] as Map<String, dynamic>?;
        
        // Build requirements from project details
        ServiceRequirements requirements;
        if (projectDetails != null) {
          final description = projectDetails['description'] as String?;
          final links = (projectDetails['referenceLinks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList();
          final attachedFiles = projectDetails['attachedFiles'] as List<dynamic>?;
          
          // Convert attached files to ServiceFile objects
          List<ServiceFile>? files;
          if (attachedFiles != null && attachedFiles.isNotEmpty) {
            files = attachedFiles.map((file) {
              if (file is Map<String, dynamic>) {
                return ServiceFile(
                  id: file['id']?.toString() ?? '',
                  name: file['name']?.toString() ?? '',
                  mimeType: file['mimeType']?.toString() ?? '',
                  size: file['size'] as int? ?? 0,
                );
              }
              return null;
            }).whereType<ServiceFile>().toList();
          }
          
          requirements = ServiceRequirements(
            description: description,
            links: links,
            files: files,
          );
        } else {
          requirements = ServiceRequirements();
        }
        
        return ServiceOrderItem(
          id: int.tryParse(item.id) ?? 0,
          reference: ReferenceGenerator.generateNumericReference('SRV'),
          requirements: requirements,
        );
      }).toList();

      final request = ServiceOrderRequest(
        items: orderItems,
        method: _paymentMethod.toUpperCase(),
        currency: 'NGN',
        amount: breakdown.total,
        paymentRef: cartState.reference ?? '',
        remark: 'Order for services',
      );

      // Submit service order
      ref.read(checkoutProvider.notifier).submitServiceOrder(request);
    } else if (checkoutType == 'campaign') {
      // Build campaign order request
      final campaignReference = ReferenceGenerator.generateNumericReference('CMP');
      
      final orderItems = items.map((item) {
        // Extract campaign creatives from metadata
        final metadata = item.metadata ?? {};
        final campaignCreatives = metadata['campaignCreatives'] as Map<String, dynamic>?;
        
        // Build creatives list
        List<CampaignCreative> creatives = [];
        if (campaignCreatives != null) {
          final creativeFiles = campaignCreatives['creativeFiles'] as List<dynamic>?;
          if (creativeFiles != null) {
            creatives = creativeFiles.map((file) {
              if (file is Map<String, dynamic>) {
                return CampaignCreative(
                  id: file['id']?.toString() ?? '',
                  name: file['name']?.toString() ?? '',
                  mimeType: file['mimeType']?.toString() ?? '',
                  size: file['size'] as int? ?? 0,
                  description: 'Campaign creative',
                  status: 'PENDING',
                );
              }
              return null;
            }).whereType<CampaignCreative>().toList();
          }
        }
        
        return CampaignOrderItem(
          id: item.id,
          adSlotId: int.tryParse(item.id) ?? 0,
          quantity: 1,
          creatives: creatives,
        );
      }).toList();

      final request = CampaignOrderRequest(
        reference: campaignReference,
        items: orderItems,
        method: _paymentMethod.toUpperCase(),
        currency: 'NGN',
        amount: breakdown.total,
        paymentRef: cartState.reference ?? '',
        remark: 'Campaign order',
      );

      // Submit campaign order
      ref.read(checkoutProvider.notifier).submitCampaignOrder(request);
    } else {
      // Build template order request
      final orderItems = items.map((item) {
        return TemplateOrderItem(
          id: int.tryParse(item.id) ?? 0,
          reference: ReferenceGenerator.generateReference(),
        );
      }).toList();

      final request = TemplateOrderRequest(
        items: orderItems,
        method: _paymentMethod.toUpperCase(),
        currency: 'NGN',
        amount: breakdown.total,
        paymentRef: cartState.reference ?? '',
        remark: 'Purchase of design templates',
      );

      // Submit template order
      ref.read(checkoutProvider.notifier).submitTemplateOrder(request);
    }
  }

  Future<void> _handlePaystackPayment(
    BuildContext context,
    String checkoutType,
    List<CartItem> items,
    PricingBreakdown breakdown,
  ) async {
    final authState = ref.read(authNotifierProvider);
    final user = authState.singleData;
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again.')),
      );
      return;
    }

    // Generate payment reference
    final paymentReference = ReferenceGenerator.generatePaymentReference(
      checkoutType == 'template' ? 'template' :
      checkoutType == 'creative' ? 'creative' :
      checkoutType == 'service' ? 'service' : 'campaign'
    );

    // Build metadata based on checkout type
    Map<String, dynamic> additionalData = {};
    
    if (checkoutType == 'template') {
      additionalData = {
        'templateIds': items.map((item) => item.id).toList(),
        'itemCount': items.length,
      };
    } else if (checkoutType == 'creative') {
      additionalData = {
        'creativeIds': items.map((item) => item.id).toList(),
        'itemCount': items.length,
      };
    } else if (checkoutType == 'service') {
      additionalData = {
        'serviceIds': items.map((item) => item.id).toList(),
        'itemCount': items.length,
      };
    } else if (checkoutType == 'campaign') {
      additionalData = {
        'adSlotIds': items.map((item) => item.id).toList(),
        'itemCount': items.length,
      };
    }

    // Create payment request
    final paymentRequest = PaymentHelper.createCustomPayment(
      email: user.emailAddress,
      userId: user.id,
      purpose: checkoutType == 'template' ? 'template_purchase' :
               checkoutType == 'creative' ? 'creative_purchase' :
               checkoutType == 'service' ? 'service_order_payment' : 'campaign_payment',
      totalAmount: breakdown.total,
      referencePrefix: checkoutType,
      additionalData: additionalData,
    );

    // Process payment with Paystack SDK
    await ref.read(paymentNotifierProvider.notifier).processPayment(context, paymentRequest);

    // Listen for payment result
    ref.listen<DataState>(paymentNotifierProvider, (previous, next) {
      if (next.isDataAvailable) {
        // Payment successful and webhook processed!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear cart
        ref.read(cartProvider.notifier).clearItemsByType(checkoutType);
        
        // Show success modal
        OrderSuccessModal.show(
          context,
          orderType: checkoutType,
          orderId: paymentReference,
        );
      } else if (next.message != null && !next.isInitialLoading) {
        // Payment failed or timeout
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
