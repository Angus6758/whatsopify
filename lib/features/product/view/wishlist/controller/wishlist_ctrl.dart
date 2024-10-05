import 'dart:async';


import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/user_content/wishlist_model.dart';
import 'package:seller_management/features/product/view/user_dash/controller/dash_ctrl.dart';
import 'package:seller_management/features/product/view/user_dash/provider/user_dash_provider.dart';
import 'package:seller_management/features/product/view/user_dash/repository/dash_repo.dart';
import 'package:seller_management/features/product/view/wishlist/repository/wishlist_repo.dart';

final wishlistCtrlProvider =
    AsyncNotifierProvider<WishlistCtrl, ItemListWithPageData<WishlistData>>(
        WishlistCtrl.new);

class WishlistCtrl extends AsyncNotifier<ItemListWithPageData<WishlistData>> {
  @override
  FutureOr<ItemListWithPageData<WishlistData>> build() {
    final isLoggedIn = ref.watch(authCtrlProvider);
    if (!isLoggedIn) return const ItemListWithPageData.empty();

    final wishlists =
        ref.watch(userDashProvider.select((value) => value?.wishlists));
    return wishlists ?? const ItemListWithPageData.empty();
  }

  WishlistRepo get _repo => ref.watch(wishlistRepoProvider);

  Future<void> paginationHandler(bool isNext) async {
    final stateData = await future;
    final url = isNext
        ? stateData.pagination?.nextPageUrl
        : stateData.pagination?.prevPageUrl;

    if (url == null) return;
    state = const AsyncValue.loading();
    final repo = ref.read(userDashRepoProvider);
    final res = await repo.dashFromUrl(url);
    res.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) {
        final orderList = r.data.wishlists;
        return state = AsyncData(orderList);
      },
    );
  }

  Future<void> reload() async {
    if (!ref.watch(authCtrlProvider)) return;
    state = const AsyncValue.loading();
    await ref.read(userDashCtrlProvider.notifier).reload();
    ref.invalidateSelf();
  }

  Future<void> addToWishlist(String? productUid) async {
    if (productUid == null) {
      Toaster.showError('Something went Wrong');
      return;
    }
    final res = await _repo.addToWishlist(productUid);

    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        Toaster.showSuccess(r.data.message);
        await ref.read(userDashCtrlProvider.notifier).reload();
      },
    );
  }

  Future<void> deleteWishlist(String uid) async {
    final res = await _repo.deleteWishlist(uid);

    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(userDashCtrlProvider.notifier).reload();
        Toaster.showSuccess(r.data.message);
      },
    );
  }
}
