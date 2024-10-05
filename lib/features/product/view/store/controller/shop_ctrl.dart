import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/content/store_model.dart';
import 'package:seller_management/features/product/view/store/repository/shop_repo.dart';

final storeDetailsCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    StoreDetailsCtrlNotifier,
    StoreDetailsModel,
    String>(StoreDetailsCtrlNotifier.new);

class StoreDetailsCtrlNotifier
    extends AutoDisposeFamilyAsyncNotifier<StoreDetailsModel, String> {
  @override
  FutureOr<StoreDetailsModel> build(arg) async {
    final data = await ref.watch(storeRepoProvider).shopDetails(arg);
    return data.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  Future<void> reload() async {
    ref.invalidateSelf();
  }

  Future<void> next(bool isRegular) async {
    final stateData = await future;
    final url = isRegular
        ? stateData.products.pagination?.nextPageUrl
        : stateData.digitalProducts.pagination?.nextPageUrl;
    if (url == null) return;
    final data = await ref.watch(storeRepoProvider).paginateFromUrl(url);
    state = data.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r.data),
    );
  }

  Future<void> previous(bool isRegular) async {
    final stateData = await future;
    final url = isRegular
        ? stateData.products.pagination?.nextPageUrl
        : stateData.digitalProducts.pagination?.nextPageUrl;
    if (url == null) return;
    final data = await ref.watch(storeRepoProvider).paginateFromUrl(url);
    state = data.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r.data),
    );
  }

  Future<void> followShop() async {
    final data = await ref.watch(storeRepoProvider).followShop(arg);
    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        reload();
        return Toaster.showSuccess(r.data);
      },
    );
  }
}
