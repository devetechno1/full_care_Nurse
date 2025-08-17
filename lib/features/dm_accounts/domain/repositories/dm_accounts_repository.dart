import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_delivery/api/api_client.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:sixam_mart_delivery/features/dm_accounts/domain/repositories/dm_accounts_repository_interface.dart';

class DmAccountsRepository implements DmAccountsRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  DmAccountsRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

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
  }) async {
    final token = _getUserToken();

    final params = <String, String>{
      'token': token,
      'limit': '$limit',
      'offset': '$offset',
      if (inOut != null && inOut.isNotEmpty) 'in_out': inOut,
      if (target != null && target.isNotEmpty) 'target': target,
      if (payMethod != null && payMethod.isNotEmpty) 'pay_method': payMethod,
      if (orderId != null) 'order_id': '$orderId',
      if (from != null && from.isNotEmpty) 'from': from,
      if (to != null && to.isNotEmpty) 'to': to,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = StringBuffer(AppConstants.dmAccountsUri);
    if (params.isNotEmpty) {
      uri.write('?');
      uri.write(params.entries.map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}'
      ).join('&'));
    }

    final Response res = await apiClient.getData(uri.toString(), handleError: true);
    return res;
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  // Unused CRUD from RepositoryInterface
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
