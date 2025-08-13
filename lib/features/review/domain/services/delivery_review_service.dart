import 'package:get/get.dart';
import 'package:sixam_mart_delivery/features/review/domain/models/delivery_review_model.dart';
import 'package:sixam_mart_delivery/features/review/domain/repositories/delivery_review_repository_interface.dart';
import 'package:sixam_mart_delivery/features/review/domain/services/delivery_review_service_interface.dart';

class DeliveryReviewService implements DeliveryReviewServiceInterface {
  final DeliveryReviewRepositoryInterface deliveryReviewRepositoryInterface;

  DeliveryReviewService({required this.deliveryReviewRepositoryInterface});

  @override
  Future<DeliveryReviewsPage?> getDeliveryManReviews({
    required int deliveryId,
    required int page,
    int limit = 15,
  }) async {
    final Response res = await deliveryReviewRepositoryInterface.getDeliveryManReviews(
      deliveryId: deliveryId,
      page: page,
      limit: limit,
    );

    if (res.statusCode == 200 && res.body is Map<String, dynamic>) {
      return DeliveryReviewsPage.fromJson(res.body);
    }
    return null;
  }
}
