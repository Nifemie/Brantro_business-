class CartItem {
  final String id;
  final String type; // 'service', 'adslot', 'template', 'creative'
  final String title;
  final String description;
  final String price;
  final String? imageUrl;
  final String? sellerName;
  final String? sellerType;
  final String? duration;
  final String? reach;
  final String? location;
  final Map<String, dynamic> metadata;

  CartItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    this.sellerName,
    this.sellerType,
    this.duration,
    this.reach,
    this.location,
    this.metadata = const {},
  });

  factory CartItem.fromService(Map<String, dynamic> service) {
    return CartItem(
      id: service['id']?.toString() ?? '',
      type: 'service',
      title: service['title'] ?? '',
      description: service['description'] ?? '',
      price: service['price'] ?? '0',
      imageUrl: service['imageUrl'],
      sellerName: service['provider'],
      sellerType: service['badge'],
      duration: service['duration'],
      metadata: service,
    );
  }

  factory CartItem.fromAdSlot(Map<String, dynamic> adSlot) {
    return CartItem(
      id: adSlot['id']?.toString() ?? '',
      type: 'adslot',
      title: adSlot['title'] ?? '',
      description: adSlot['description'] ?? '',
      price: adSlot['price'] ?? '0',
      imageUrl: adSlot['imageUrl'],
      sellerName: adSlot['sellerName'],
      sellerType: adSlot['sellerType'],
      reach: adSlot['reach'],
      location: adSlot['location'],
      metadata: adSlot,
    );
  }

  factory CartItem.fromTemplate(Map<String, dynamic> template) {
    // Get thumbnail and construct full URL if needed
    String? imageUrl = template['thumbnail'];
    if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = 'https://realta360.b-cdn.net/$imageUrl';
    }
    
    return CartItem(
      id: template['id']?.toString() ?? '',
      type: 'template',
      title: template['title'] ?? '',
      description: template['description'] ?? '',
      price: template['formattedPrice'] ?? template['price'] ?? '0',
      imageUrl: imageUrl,
      sellerName: 'Brantro Africa',
      sellerType: template['type'], // AE, CANVA, PSD, etc.
      metadata: template,
    );
  }

  factory CartItem.fromCreative(Map<String, dynamic> creative) {
    // Get thumbnail and construct full URL if needed
    String? imageUrl = creative['thumbnail'];
    if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = 'https://realta360.b-cdn.net/$imageUrl';
    }
    
    return CartItem(
      id: creative['id']?.toString() ?? '',
      type: 'creative',
      title: creative['title'] ?? '',
      description: creative['description'] ?? '',
      price: creative['formattedPrice'] ?? creative['price'] ?? '0',
      imageUrl: imageUrl,
      sellerName: 'Brantro Africa',
      sellerType: creative['type'], // IMAGE, VIDEO, ANIMATION, etc.
      metadata: creative,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'sellerName': sellerName,
      'sellerType': sellerType,
      'duration': duration,
      'reach': reach,
      'location': location,
      'metadata': metadata,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      type: json['type'] ?? 'service',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      imageUrl: json['imageUrl'],
      sellerName: json['sellerName'],
      sellerType: json['sellerType'],
      duration: json['duration'],
      reach: json['reach'],
      location: json['location'],
      metadata: json['metadata'] ?? {},
    );
  }

  double get priceValue {
    // Remove currency symbols and parse
    final cleanPrice = price.replaceAll(RegExp(r'[₦,K]'), '');
    return double.tryParse(cleanPrice) ?? 0;
  }
}
