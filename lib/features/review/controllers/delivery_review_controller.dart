import 'package:get/get.dart';
import 'package:sixam_mart_delivery/features/review/domain/models/delivery_review_model.dart';
import 'package:sixam_mart_delivery/features/review/domain/services/delivery_review_service_interface.dart';

class DeliveryReviewController extends GetxController implements GetxService {
  final DeliveryReviewServiceInterface deliveryReviewServiceInterface;

  DeliveryReviewController({required this.deliveryReviewServiceInterface});

  static const int _defaultLimit = 15;     // Page size required by API

  int? _deliveryId;
  int? get deliveryId => _deliveryId;

  double? _averageRating;
  double? get averageRating => _averageRating;

  List<DeliveryReview>? _reviews;
  List<DeliveryReview>? get reviews => _reviews;

  int? _totalSize;
  int? get totalSize => _totalSize;

  int? _offset; // current page (1-based)
  int? get offset => _offset;

  bool _loading = false;
  bool get loading => _loading;

  // Set current delivery man ID; clears cached list if changed
  void setDelivery(int id) {
    if (_deliveryId != id) {
      _deliveryId = id;
      _averageRating = null;
      _reviews = null;
      _totalSize = null;
      _offset = null;
      update();
    }
  }

  // Fetch a specific page (1-based)
  Future<void> getReviews({required int deliveryId, required int page}) async {
    if (_loading) return;
    _loading = true;
    update();

    _deliveryId = deliveryId;

    final pageData = await deliveryReviewServiceInterface.getDeliveryManReviews(
      deliveryId: deliveryId,
      page: page,
      limit: _defaultLimit,
    );

    if (pageData != null) {
      _averageRating = pageData.averageRating;

      if (page == 1) {
        // Fresh load
        _reviews = pageData.reviews ?? <DeliveryReview>[];
        _totalSize = pageData.totalSize ?? 0;
        _offset = pageData.offset ?? 1;
      } else {
        // Append next page
        _reviews ??= <DeliveryReview>[];
        _reviews!.addAll(pageData.reviews ?? <DeliveryReview>[]);
        _totalSize = pageData.totalSize ?? _totalSize;
        _offset = pageData.offset ?? _offset;
      }
    }

    _loading = false;
    update();
  }
}
