import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/cart_item_model.dart';
import '../../../core/utils/reference_generator.dart';
import '../../../core/utils/pricing_calculator.dart';

const String _cartStorageKey = 'brantro_cart_items';
const String _cartReferenceKey = 'brantro_cart_reference';

class CartState {
  final String? reference;
  final List<CartItem> items;
  final bool isLoading;
  final String? message;

  CartState({
    this.reference,
    this.items = const [],
    this.isLoading = false,
    this.message,
  });

  CartState copyWith({
    String? reference,
    List<CartItem>? items,
    bool? isLoading,
    String? message,
  }) {
    return CartState(
      reference: reference ?? this.reference,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      reference: json['reference'],
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  int get itemCount => items.length;

  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.priceValue);
  }

  double get vat => PricingCalculator.calculateVAT(subtotal);

  double get serviceCharge => PricingCalculator.calculateServiceCharge(subtotal);

  double get total => subtotal + vat + serviceCharge;

  PricingBreakdown get breakdown => PricingCalculator.getBreakdown(subtotal);

  String get formattedSubtotal => PricingCalculator.formatAmountFull(subtotal);
  String get formattedVAT => PricingCalculator.formatAmountFull(vat);
  String get formattedServiceCharge => PricingCalculator.formatAmountFull(serviceCharge);
  String get formattedTotal => PricingCalculator.formatAmountFull(total);

  bool isWalletSufficient(double walletBalance) {
    return PricingCalculator.isWalletSufficient(walletBalance, total);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartStorageKey);
      
      if (cartJson != null) {
        final decoded = json.decode(cartJson);
        state = CartState.fromJson(decoded);
      }
    } catch (e) {
      // If loading fails, start with empty cart
      state = CartState();
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(state.toJson());
      await prefs.setString(_cartStorageKey, cartJson);
    } catch (e) {
      // Silently fail if save fails
    }
  }

  void addItem(CartItem item) {
    // Check if item already exists
    final existingIndex = state.items.indexWhere((i) => i.id == item.id && i.type == item.type);
    
    if (existingIndex >= 0) {
      state = state.copyWith(
        message: 'Item already in cart',
      );
      return;
    }

    // Generate cart reference if this is the first item
    // Use appropriate prefix based on item type
    String cartReference = state.reference ?? _generateReferenceForType(item.type);

    state = state.copyWith(
      reference: cartReference,
      items: [...state.items, item],
      message: 'Added to cart',
    );
    
    _saveCart();
  }

  String _generateReferenceForType(String type) {
    switch (type) {
      case 'template':
        return ReferenceGenerator.generateNumericReference('TPL');
      case 'service':
        return ReferenceGenerator.generateNumericReference('SRV');
      case 'creative':
        return ReferenceGenerator.generateNumericReference('CRTV');
      case 'adslot':
      case 'campaign':
        return ReferenceGenerator.generateNumericReference('CMP');
      default:
        return ReferenceGenerator.generateNumericReference('ORD');
    }
  }

  void removeItem(String id, String type) {
    final updatedItems = state.items.where((item) => !(item.id == id && item.type == type)).toList();
    
    state = state.copyWith(
      items: updatedItems,
      reference: updatedItems.isEmpty ? null : state.reference, // Clear reference if cart is empty
      message: 'Removed from cart',
    );
    
    _saveCart();
  }

  void clearCart() {
    state = state.copyWith(
      items: [],
      reference: null, // Clear reference when cart is cleared
      message: 'Cart cleared',
    );
    
    _saveCart();
  }

  void clearItemsByType(String type) {
    final updatedItems = state.items.where((item) => item.type != type).toList();
    
    state = state.copyWith(
      items: updatedItems,
      reference: updatedItems.isEmpty ? null : state.reference, // Clear reference if cart is empty
      message: 'Checkout completed',
    );
    
    _saveCart();
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void updateItemMetadata(String id, Map<String, dynamic> metadata) {
    final updatedItems = state.items.map((item) {
      if (item.id == id) {
        return CartItem(
          id: item.id,
          type: item.type,
          title: item.title,
          description: item.description,
          price: item.price,
          imageUrl: item.imageUrl,
          sellerName: item.sellerName,
          sellerType: item.sellerType,
          duration: item.duration,
          reach: item.reach,
          location: item.location,
          metadata: metadata,
        );
      }
      return item;
    }).toList();
    
    state = state.copyWith(items: updatedItems);
    _saveCart();
  }

  bool isInCart(String id, String type) {
    return state.items.any((item) => item.id == id && item.type == type);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
