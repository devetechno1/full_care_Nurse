// Models for delivery reviews summary response.
// API: GET /api/v1/delivery-man/{delivery_man_id}/reviews/summary?limit=15&offset=1&has_comment=1

class DeliveryReview {
  int? id;
  int? userId;
  int? deliveryManId;
  int? rating;
  String? comment;
  DateTime? createdAt;

  DeliveryReview({
    this.id,
    this.userId,
    this.deliveryManId,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory DeliveryReview.fromJson(Map<String, dynamic> json) {
    return DeliveryReview(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      deliveryManId: json['delivery_man_id'] as int?,
      rating: json['rating'] is num ? (json['rating'] as num).toInt() : null,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}

class DeliveryReviewsPage {
  // Top-level pagination & meta fields (no nested 'pagination' object)
  int? totalSize;        // json['total_size']
  int? limit;            // json['limit']
  int? offset;           // json['offset'] -> treated as page (1-based)
  double? averageRating; // json['average_rating']
  List<DeliveryReview>? reviews;

  DeliveryReviewsPage({
    this.totalSize,
    this.limit,
    this.offset,
    this.averageRating,
    this.reviews,
  });

  factory DeliveryReviewsPage.fromJson(Map<String, dynamic> json) {
    final list = (json['reviews'] as List?) ?? const [];
    return DeliveryReviewsPage(
      totalSize: json['total_size'] as int?,
      limit: json['limit'] as int?,
      offset: json['offset'] as int?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviews: list.map((e) => DeliveryReview.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
