import 'dart:async';

import 'package:collection/collection.dart';
import 'package:seller_management/features/product/controller/list_ctrls.dart';
import 'package:seller_management/main.export.dart';

import '../repository/product_repo.dart';

//----------------------------------------
// Product Details
//----------------------------------------

final productDetailsCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    ProductDetailsCtrlNotifierNotifier, ProductModel, String>(
  ProductDetailsCtrlNotifierNotifier.new,
);

class ProductDetailsCtrlNotifierNotifier
    extends AutoDisposeFamilyAsyncNotifier<ProductModel, String> {
  final _repo = locate<ProductRepo>();

  Future<void> reload([bool silent = false]) async {
    if (!silent) state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> deleteGalleryImage(String id) async {
    final data = await _repo.deleteGalleryImage(id);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(physicalProductCtrlProvider);
    ref.invalidate(digitalProductCtrlProvider);
  }

  Future<void> delete() async {
    final data = await _repo.productDelete(arg);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(physicalProductCtrlProvider);
    ref.invalidate(digitalProductCtrlProvider);
  }

  Future<void> restore() async {
    final data = await _repo.productRestore(arg);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(physicalProductCtrlProvider);
    ref.invalidate(digitalProductCtrlProvider);
  }

  Future<void> deletePermanently() async {
    final data = await _repo.deletePermanently(arg);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(physicalProductCtrlProvider);
    ref.invalidate(digitalProductCtrlProvider);
  }

  Future<void> attributeStore(QMap formData) async {
    final data = await _repo.storeDigitalAttribute(arg, formData);
    data.fold(
      (l) => l.toFError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> deleteAttribute(String id) async {
    final data = await _repo.attributeDelete(id);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<List<DigitalAttributeValue>> storeAttributeValue(
      String attributeId, String text) async {
    final data = await _repo.attributeValueStore(attributeId, text);
    final result = data.fold(
      (l) => <DigitalAttributeValue>[],
      (r) {
        state = AsyncData(r.data);
        return r.data.digitalAttributes
            .firstWhereOrNull((e) => e.uid == attributeId)
            ?.values;
      },
    );

    return result ?? [];
  }

  Future<void> attributeValueDelete(String valueId) async {
    final data = await _repo.attributeValueDelete(valueId);
    data.fold(
      (l) => l.toFError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<ProductModel> build(String arg) async {
    final data = await _repo.getProductDetails(arg);
    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }
}
