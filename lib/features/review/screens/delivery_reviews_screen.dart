import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/paginated_list_view_widget.dart';
import 'package:sixam_mart_delivery/features/review/controllers/delivery_review_controller.dart';
import 'package:sixam_mart_delivery/helper/date_converter_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';

class DeliveryReviewsScreen extends StatefulWidget {
  const DeliveryReviewsScreen({super.key});

  @override
  State<DeliveryReviewsScreen> createState() => _DeliveryReviewsScreenState();
}

class _DeliveryReviewsScreenState extends State<DeliveryReviewsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final int _deliveryId;

  @override
  void initState() {
    super.initState();
    // Get deliveryId from route query (?deliveryId=)
    _deliveryId = int.tryParse(Get.parameters['deliveryId'] ?? '') ?? 0;

    final controller = Get.find<DeliveryReviewController>();
    controller.setDelivery(_deliveryId);

    controller.getReviews(deliveryId: _deliveryId, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'delivery_reviews'.tr, isBackButtonExist: true),
      body: GetBuilder<DeliveryReviewController>(builder: (controller) {
        if (controller.reviews == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.getReviews(deliveryId: _deliveryId, page: 1),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                width: 1170,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Average rating header card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).disabledColor.withOpacity(0.1),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            (controller.averageRating ?? 0).toStringAsFixed(2),
                            style: robotoBold.copyWith(fontSize: 26),
                          ),
                          const SizedBox(width: 10),
                          _buildStars((controller.averageRating ?? 0).toDouble()),
                        ],
                      ),
                    ),

                    // Reviews list with built-in pagination
                    PaginatedListViewWidget(
                      scrollController: _scrollController,
                      onPaginate: (int? nextPage) => controller.getReviews(
                        deliveryId: _deliveryId,
                        page: nextPage ?? 1,
                      ),
                      totalSize: controller.totalSize,
                      offset: controller.offset,
                      productView: ListView.separated(
                        itemCount: controller.reviews!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = controller.reviews![index];
                          return Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).disabledColor.withOpacity(0.08),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header: avatar + anonymous name + date + stars
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 18,
                                      child: Icon(Icons.person_outline),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Always anonymous per requirement
                                          Text('anonymous_user'.tr, style: robotoMedium),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.createdAt != null
                                                ? DateConverterHelper.localDateToIsoStringAMPM(item.createdAt!)
                                                : '',
                                            style: robotoRegular.copyWith(
                                              color: Theme.of(context).disabledColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildStars((item.rating ?? 0).toDouble()),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Comment (fallback to hyphen if empty)
                                Text(
                                  (item.comment ?? '').isEmpty ? '-' : item.comment!,
                                  style: robotoRegular,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // Simple star builder: full/half/empty based on double value
  Widget _buildStars(double value) {
    final int full = value.floor();
    final bool half = (value - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < full) return Icon(Icons.star, size: 18, color: context.theme.primaryColor);
        if (i == full && half) return Icon(Icons.star_half, size: 18, color: context.theme.primaryColor);
        return Icon(Icons.star_border, size: 18, color: context.theme.primaryColor);
      }),
    );
  }
}
