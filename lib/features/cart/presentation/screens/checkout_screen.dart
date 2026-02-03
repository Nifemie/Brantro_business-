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
import '../../../../core/utils/pricing_calculator.dart';
import '../../../../core/utils/reference_generator.dart';
import '../widgets/payment_method_section.dart';
import '../widgets/checkout_header.dart';
import '../widgets/order_summary.dart';
import '../widgets/cart_item_card.dart';

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
      if (next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: next.isSuccess ? Colors.green : Colors.red,
          ),
        );
        
        if (next.isSuccess) {
          // Clear only the items that were checked out
          Future.delayed(const Duration(seconds: 1), () {
            ref.read(cartProvider.notifier).clearItemsByType(checkoutType);
            
            // Navigate to appropriate screen based on checkout type
            switch (checkoutType) {
              case 'template':
                context.go('/my-templates');
                break;
              case 'creative':
                context.go('/my-creatives');
                break;
              case 'campaign':
                context.go('/campaigns');
                break;
              case 'service':
                // For services, go to home
                context.go('/home');
                break;
              default:
                context.go('/home');
            }
          });
        }
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text('Your cart is empty', style: AppTexts.h4()),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.push('/template'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
            ),
            child: const Text('Browse Templates'),
          ),
        ],
      ),
    );
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
}
