import 'dart:async';

import 'package:seller_management/features/withdraw/repository/withdraw_repo.dart';
import 'package:seller_management/main.export.dart';

final withdrawMethodsProvider =
    FutureProvider.autoDispose<List<WithdrawMethod>>((ref) async {
  final data = await locate<WithdrawRepo>().getMethods();

  return data.fold((l) => l.toFError(), (r) => r.data);
});

/// --------------------------------------------------------
/// Withdraw List
/// --------------------------------------------------------

final withdrawListCtrlProvider = AutoDisposeAsyncNotifierProvider<
    WithdrawListCtrlNotifier,
    PagedItem<WithdrawData>>(WithdrawListCtrlNotifier.new);

class WithdrawListCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<WithdrawData>> {
  final _repo = locate<WithdrawRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> search(String query) async {
    final data = await _repo.getWithdrawList(query);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getWithdrawListFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<WithdrawData>> build() async {
    final data = await _repo.getWithdrawList();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

/// --------------------------------------------------------
/// Withdraw Controller
/// --------------------------------------------------------
final withdrawCtrlProvider =
    AutoDisposeNotifierProvider<WithdrawCtrlNotifier, WithdrawData?>(
        WithdrawCtrlNotifier.new);

class WithdrawCtrlNotifier extends AutoDisposeNotifier<WithdrawData?> {
  final _repo = locate<WithdrawRepo>();

  @override
  WithdrawData? build() {
    return null;
  }

  Future<void> request(String id, String amount) async {
    ref.keepAlive();
    final data = await _repo.request(id, amount);

    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        state = r.data.data;
        Toaster.showSuccess(r.data.msg);
      },
    );
  }

  Future<void> store(String id, QMap formData) async {
    final data = await _repo.storeWithdraw(id, formData);

    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );

    ref.invalidateSelf();
    ref.invalidate(withdrawListCtrlProvider);
  }
}
