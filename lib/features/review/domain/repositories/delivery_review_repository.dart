import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_delivery/api/api_client.dart';
import 'package:sixam_mart_delivery/features/review/domain/repositories/delivery_review_repository_interface.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';

class DeliveryReviewRepository implements DeliveryReviewRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  DeliveryReviewRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future getDeliveryManReviews({
    required int deliveryId,
    required int page,
    int limit = 15,
  }) async {
    return await apiClient.getData('${AppConstants.reviews}/$deliveryId?limit=$limit&offset=$page');
  }

  // Unused CRUD methods from RepositoryInterface
  @override
  Future add(value) => throw UnimplementedError();
  @override
  Future delete(int? id) => throw UnimplementedError();
  @override
  Future get(int? id) => throw UnimplementedError();
  @override
  Future getList() => throw UnimplementedError();
  @override
  Future update(Map<String, dynamic> body) => throw UnimplementedError();
}
