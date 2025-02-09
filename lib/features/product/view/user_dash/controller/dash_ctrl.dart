import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:seller_management/features/product/view/user_content/user_dash_model.dart';
import 'package:seller_management/features/product/view/user_dash/provider/user_dash_provider.dart';
import 'package:seller_management/features/product/view/user_dash/repository/dash_repo.dart';

final userDashCtrlProvider =
    AsyncNotifierProvider<UserDashCtrl, UserDashModel>(UserDashCtrl.new);

class UserDashCtrl extends AsyncNotifier<UserDashModel> {
  Future<void> _setDashState(UserDashModel dash) async {
    final pref = ref.watch(sharedPrefProvider);
    final result = await pref.setString(CachedKeys.userDash, dash.toJson());
    if (result) {
      ref.invalidate(userDashProvider);
    }
  }

  UserDashRepo get _repo => ref.watch(userDashRepoProvider);

  Future<UserDashModel> _init() async {
    final res = await _repo.getUserDash();
    print("User Dash Response: ${res}"); // Log API response
    return res.fold(
      (l) async => Future.error(l.message, l.stackTrace),
      (r) async {
        await _setDashState(r.data);
        return r.data;
      },
    );
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _init());
  }

  Future<void> orderPaginationHandler(bool isNext, bool isDigital) async {
    final stateData = await future;
    final url = isNext
        ? stateData.orders.pagination?.nextPageUrl
        : stateData.orders.pagination?.prevPageUrl;
    final urlDigital = isNext
        ? stateData.orders.pagination?.nextPageUrl
        : stateData.orders.pagination?.prevPageUrl;

    if (url == null || urlDigital == null) return;
    state = const AsyncValue.loading();

    final res = await _repo.dashFromUrl(isDigital ? urlDigital : url);
    res.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) {
        final orderList = isDigital
            ? stateData.updateDigitalOrderList(r.data.digitalOrders)
            : stateData.updateOrderList(r.data.orders);
        return state = AsyncData(orderList);
      },
    );
  }

  @override
  FutureOr<UserDashModel> build() async {
    return await _init();
  }
}