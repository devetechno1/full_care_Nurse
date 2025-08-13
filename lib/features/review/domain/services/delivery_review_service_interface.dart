import 'package:sixam_mart_delivery/features/review/domain/models/delivery_review_model.dart';

abstract class DeliveryReviewServiceInterface {
  // Service wrapper: returns parsed DeliveryReviewsPage (or null on error).
  Future<DeliveryReviewsPage?> getDeliveryManReviews({
    required int deliveryId,
    required int page,
    int limit,
  });
}
