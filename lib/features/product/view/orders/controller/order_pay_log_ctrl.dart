

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/orders/repository/order_repo.dart';
import 'package:seller_management/features/product/view/user_content/order_model.dart';

final orderPaymentLogProvider =
    NotifierProvider<OrderPaymentLogNotifier, PaymentLog?>(
        OrderPaymentLogNotifier.new);

class OrderPaymentLogNotifier extends Notifier<PaymentLog?> {
  @override
  PaymentLog? build() => null;

  Future<String> statusCheck(String trx) async {
    final result = await ref.watch(orderRepoProvider).getPaymentLog(trx);

    return result.fold(
      (l) => '3',
      (r) => r.data.payStatus,
    );
  }
}
