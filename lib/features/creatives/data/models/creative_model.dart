class CreativeModel {
  final int id;
  final String title;
  final String description;
  final String type;
  final String format;
  final String fileUrl;
  final List<String> fileFormat;
  final double fileSizeMB;
  final String price;
  final String? discount;
  final int downloads;
  final double averageRating;
  final int totalLikes;
  final String tags;
  final String? thumbnail;
  final int? durationInSeconds;
  final int? width;
  final int? height;
  final String status;
  final int ownerId;
  final CreativeOwner? owner;

  CreativeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.format,
    required this.fileUrl,
    required this.fileFormat,
    required this.fileSizeMB,
    required this.price,
    this.discount,
    required this.downloads,
    required this.averageRating,
    required this.totalLikes,
    required this.tags,
    this.thumbnail,
    this.durationInSeconds,
    this.width,
    this.height,
    required this.status,
    required this.ownerId,
    this.owner,
  });

  factory CreativeModel.fromJson(Map<String, dynamic> json) {
    return CreativeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      format: json['format'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileFormat: (json['fileFormat'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      fileSizeMB: (json['fileSizeMB'] as num?)?.toDouble() ?? 0.0,
      price: json['price']?.toString() ?? '0',
      discount: json['discount']?.toString(),
      downloads: json['downloads'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] ?? 0,
      tags: json['tags'] ?? '',
      thumbnail: json['thumbnail'],
      durationInSeconds: json['durationInSeconds'],
      width: json['width'],
      height: json['height'],
      status: json['status'] ?? 'ACTIVE',
      ownerId: json['ownerId'] ?? 0,
      owner: json['owner'] != null
          ? CreativeOwner.fromJson(json['owner'])
          : null,
    );
  }

  String get formattedPrice {
    final priceValue = double.tryParse(price) ?? 0;
    return '₦${priceValue.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  String get fileSizeFormatted => '${fileSizeMB.toStringAsFixed(1)}MB';

  String get dimensionsFormatted {
    if (width != null && height != null) {
      return '$width × ${height}px';
    }
    return '';
  }

  List<String> get tagsList => tags.split(',').map((e) => e.trim()).toList();

  // Get full image URL
  String get thumbnailUrl {
    if (thumbnail == null || thumbnail!.isEmpty) {
      return '';
    }
    if (thumbnail!.startsWith('http')) {
      return thumbnail!;
    }
    return 'https://realta360.b-cdn.net/$thumbnail';
  }

  // Strip HTML tags from description
  String get cleanDescription {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ') // Replace non-breaking spaces
        .replaceAll('&amp;', '&') // Replace ampersand
        .replaceAll('&lt;', '<') // Replace less than
        .replaceAll('&gt;', '>') // Replace greater than
        .replaceAll('&quot;', '"') // Replace quotes
        .trim(); // Remove leading/trailing whitespace
  }
}

class CreativeOwner {
  final int id;
  final String name;
  final String? avatarUrl;

  CreativeOwner({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory CreativeOwner.fromJson(Map<String, dynamic> json) {
    return CreativeOwner(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'],
    );
  }
}
