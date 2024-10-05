import 'dart:async';

import 'package:open_filex/open_filex.dart';
import 'package:seller_management/_core/common/pdf/pdf_repo.dart';
import 'package:seller_management/main.export.dart';

import '../repository/order_repo.dart';

final physicalOrderCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    PhysicalOrderCtrlNotifier,
    PagedItem<OrderModel>,
    String>(PhysicalOrderCtrlNotifier.new);

class PhysicalOrderCtrlNotifier
    extends AutoDisposeFamilyAsyncNotifier<PagedItem<OrderModel>, String> {
  final _repo = locate<OrderRepository>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> orderByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getOrderFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return reload();

    state = const AsyncValue.loading();
    final data = await _repo.getPhysicalOrder(search: query);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<OrderModel>> build(String arg) async {
    final data = await _repo.getPhysicalOrder(status: arg);
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

//-------------------------------------------------
// Digital Order
//-------------------------------------------------
final digitalOrderCtrlProvider =
    AsyncNotifierProvider<DigitalOrderCtrlNotifier, PagedItem<OrderModel>>(
  DigitalOrderCtrlNotifier.new,
);

class DigitalOrderCtrlNotifier extends AsyncNotifier<PagedItem<OrderModel>> {
  final _repo = locate<OrderRepository>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return reload();

    state = const AsyncValue.loading();
    final data = await _repo.getDigitalOrder(search: query);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> orderByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getOrderFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<OrderModel>> build() async {
    final data = await _repo.getDigitalOrder();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

//-------------------------------------------------
// Order Details
//-------------------------------------------------

final orderDetailsCtrlNotifier = AutoDisposeAsyncNotifierProviderFamily<
    OrderDetailsCtrlNotifierNotifier, OrderModel, String>(
  OrderDetailsCtrlNotifierNotifier.new,
);

class OrderDetailsCtrlNotifierNotifier
    extends AutoDisposeFamilyAsyncNotifier<OrderModel, String> {
  final _repo = locate<OrderRepository>();

  Future<void> downloadInvoice() async {
    final pdfRepo = locate<PDFCtrl>();
    final data = await pdfRepo.saveOrderPdf(await future);

    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(
        'Invoice saved in $r',
        () async {
          final res = await OpenFilex.open(r, type: 'application/pdf');
          Toaster.showInfo(res.message);
        },
      ),
    );
  }

  Future<void> orderStatusUpdate({required String status, String? note}) async {
    final res = await _repo.updateOrderStatus(arg, status, note ?? '');
    res.fold(
      (l) => Toaster.showError(l),
      (r) {
        Toaster.showSuccess(r.data);
        ref.invalidateSelf();
      },
    );
  }

  @override
  FutureOr<OrderModel> build(String arg) async {
    final data = await _repo.getOrderDetails(arg);
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}
