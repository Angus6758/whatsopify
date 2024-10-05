import 'dart:async';

import 'package:seller_management/main.export.dart';

import '../repository/product_repo.dart';

//----------------------------------------
// Physical Product List
//----------------------------------------

final physicalProductCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    PhysicalProductCtrlNotifier,
    PagedItem<ProductModel>,
    String?>(PhysicalProductCtrlNotifier.new);

class PhysicalProductCtrlNotifier
    extends AutoDisposeFamilyAsyncNotifier<PagedItem<ProductModel>, String?> {
  final _repo = locate<ProductRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return reload();

    state = const AsyncValue.loading();
    final data = await _repo.getPhysicalProduct(search: query);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) {
        Logger(r.data.length);
        return state = AsyncData(r.data);
      },
    );
  }

  Future<void> productByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getProductByUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<ProductModel>> build(arg) async {
    final data = await _repo.getPhysicalProduct(status: arg);
    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }
}

//----------------------------------------
// Digital Product List
//----------------------------------------

final digitalProductCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    DigitalProductCtrlNotifier, PagedItem<ProductModel>, String?>(
  DigitalProductCtrlNotifier.new,
);

class DigitalProductCtrlNotifier
    extends AutoDisposeFamilyAsyncNotifier<PagedItem<ProductModel>, String?> {
  final _repo = locate<ProductRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> productByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getProductByUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return reload();

    state = const AsyncValue.loading();
    final data = await _repo.getDigitalPRoduct(search: query);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<ProductModel>> build(arg) async {
    final data = await _repo.getDigitalPRoduct(status: arg);
    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }
}
