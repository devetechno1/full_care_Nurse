import 'package:get/get.dart';
import 'package:sixam_mart_delivery/features/dm_accounts/domain/repositories/dm_accounts_repository_interface.dart';
import 'package:sixam_mart_delivery/features/dm_accounts/domain/services/dm_accounts_service_interface.dart';

class DmAccountsService implements DmAccountsServiceInterface {
  final DmAccountsRepositoryInterface repo;
  DmAccountsService({required this.repo});

  @override
  Future<Response> getAccounts({
    required int limit,
    required int offset,
    String? inOut,
    String? target,
    String? payMethod,
    int? orderId,
    String? from,
    String? to,
    String? search,
  }) {
    return repo.getAccounts(
      limit: limit,
      offset: offset,
      inOut: inOut,
      target: target,
      payMethod: payMethod,
      orderId: orderId,
      from: from,
      to: to,
      search: search,
    );
  }
}
