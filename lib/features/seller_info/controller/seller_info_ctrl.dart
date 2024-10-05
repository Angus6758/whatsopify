import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:seller_management/features/seller_info/repository/seller_info_repo.dart';
import 'package:seller_management/main.export.dart';

final sellerCtrlProvider =
    AutoDisposeAsyncNotifierProvider<SellerCtrlNotifier, Seller>(
        SellerCtrlNotifier.new);

class SellerCtrlNotifier extends AutoDisposeAsyncNotifier<Seller> {
  final _repo = locate<SellerRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  @override
  FutureOr<Seller> build() async {
    print("we are now in the sellerCtrlProvider");
    final data = await _repo.getStoreInfo();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }

  Future<void> updateStoreInfo(QMap formData) async {
    final parts = <String, File>{};

    final body = formData.map((key, value) {
      if (key.startsWith('~')) {
        final name = key.substring(1);
        (value as Either<String, File>)
            .fold((l) => null, (r) => parts[name] = r);

        return MapEntry(key, null);
      }
      return MapEntry(key, value);
    }).nonNull();

    body['id'] = (await future).shop.id;

    final data = await _repo.updateStoreInfo(body, parts);
    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        state = AsyncData(r.data.seller);
        Toaster.showSuccess(r.message);
      },
    );
  }

  Future<void> updateSellerInfo(QMap formData, File? file) async {
    final data = await _repo.updateSellerInfo(formData, file);
    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        state = AsyncData(r.data.seller);
        Toaster.showSuccess(r.message);
      },
    );
  }
}
