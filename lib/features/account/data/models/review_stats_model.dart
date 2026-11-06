class ReviewStatsModel {
  final double averageRating;
  final int totalReviews;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;

  const ReviewStatsModel({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.fiveStarCount = 0,
    this.fourStarCount = 0,
    this.threeStarCount = 0,
    this.twoStarCount = 0,
    this.oneStarCount = 0,
  });

  factory ReviewStatsModel.fromJson(Map<String, dynamic> json) {
    final rawAvg = json['averageRating'] ?? json['rating'] ?? json['average'] ?? 0.0;
    final avg = (rawAvg is num) ? rawAvg.toDouble() : 0.0;

    final total = (json['totalReviews'] as num?)?.toInt() ??
        (json['count'] as num?)?.toInt() ??
        (json['total'] as num?)?.toInt() ??
        0;

    final distribution = json['distribution'] is Map<String, dynamic>
        ? json['distribution'] as Map<String, dynamic>
        : (json['breakdown'] is Map<String, dynamic>
            ? json['breakdown'] as Map<String, dynamic>
            : null);

    return ReviewStatsModel(
      averageRating: avg,
      totalReviews: total,
      fiveStarCount: (distribution?['5'] as num?)?.toInt() ?? (json['fiveStarCount'] as num?)?.toInt() ?? 0,
      fourStarCount: (distribution?['4'] as num?)?.toInt() ?? (json['fourStarCount'] as num?)?.toInt() ?? 0,
      threeStarCount: (distribution?['3'] as num?)?.toInt() ?? (json['threeStarCount'] as num?)?.toInt() ?? 0,
      twoStarCount: (distribution?['2'] as num?)?.toInt() ?? (json['twoStarCount'] as num?)?.toInt() ?? 0,
      oneStarCount: (distribution?['1'] as num?)?.toInt() ?? (json['oneStarCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'fiveStarCount': fiveStarCount,
      'fourStarCount': fourStarCount,
      'threeStarCount': threeStarCount,
      'twoStarCount': twoStarCount,
      'oneStarCount': oneStarCount,
    };
  }
}
