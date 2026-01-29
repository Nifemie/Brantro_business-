class TemplateModel {
  final int id;
  final String title;
  final String description;
  final int categoryId;
  final String type; // CANVA, PSD, AE, AI, PDF
  final String? designUrl;
  final String? fileUrl;
  final String thumbnail;
  final String price;
  final String discount;
  final int downloads;
  final double averageRating;
  final int totalLikes;
  final String tags;
  final String status;
  final int createdById;
  final DateTime createdAt;
  final DateTime updatedAt;

  TemplateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.type,
    this.designUrl,
    this.fileUrl,
    required this.thumbnail,
    required this.price,
    required this.discount,
    required this.downloads,
    required this.averageRating,
    required this.totalLikes,
    required this.tags,
    required this.status,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as int,
      type: json['type'] as String,
      designUrl: json['designUrl'] as String?,
      fileUrl: json['fileUrl'] as String?,
      thumbnail: json['thumbnail'] as String,
      price: json['price'] as String,
      discount: json['discount'] as String,
      downloads: json['downloads'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] as int? ?? 0,
      tags: json['tags'] as String? ?? '',
      status: json['status'] as String,
      createdById: json['createdById'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'type': type,
      'designUrl': designUrl,
      'fileUrl': fileUrl,
      'thumbnail': thumbnail,
      'price': price,
      'discount': discount,
      'downloads': downloads,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'tags': tags,
      'status': status,
      'createdById': createdById,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  bool get isFree => double.tryParse(price) == 0.0;
  
  double get priceValue => double.tryParse(price) ?? 0.0;
  
  double get discountValue => double.tryParse(discount) ?? 0.0;
  
  String get formattedPrice {
    if (isFree) return 'Free';
    return '₦${priceValue.toStringAsFixed(0)}';
  }
  
  String? get formattedOriginalPrice {
    if (isFree || discountValue == 0) return null;
    final original = priceValue / (1 - (discountValue / 100));
    return '₦${original.toStringAsFixed(0)}';
  }
  
  String? get formattedDiscount {
    if (discountValue == 0) return null;
    return '-${discountValue.toStringAsFixed(0)}% OFF';
  }
  
  List<String> get tagsList {
    return tags.split(',').map((e) => '#${e.trim()}').toList();
  }

  TemplateModel copyWith({
    int? id,
    String? title,
    String? description,
    int? categoryId,
    String? type,
    String? designUrl,
    String? fileUrl,
    String? thumbnail,
    String? price,
    String? discount,
    int? downloads,
    double? averageRating,
    int? totalLikes,
    String? tags,
    String? status,
    int? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      designUrl: designUrl ?? this.designUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      downloads: downloads ?? this.downloads,
      averageRating: averageRating ?? this.averageRating,
      totalLikes: totalLikes ?? this.totalLikes,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
