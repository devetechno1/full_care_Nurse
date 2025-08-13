import 'package:sixam_mart_delivery/interface/repository_interface.dart';

abstract class DeliveryReviewRepositoryInterface implements RepositoryInterface {
  // Fetch reviews for a delivery man with top-level pagination.
  Future<dynamic> getDeliveryManReviews({
    required int deliveryId,
    required int page,       // offset (1-based page index)
    int limit = 15,          // default as per requirement
  });
}
