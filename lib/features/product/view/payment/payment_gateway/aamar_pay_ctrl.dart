// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payment_module/payment_module.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/payment/repository/payment_repo.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';

final aamarPayCtrlProvider =
    NotifierProviderFamily<AmarPayCtrlNotifier, String, PaymentData>(
        AmarPayCtrlNotifier.new);

class AmarPayCtrlNotifier extends FamilyNotifier<String, PaymentData> {
  OrderBaseModel? get _order => ref.read(checkoutStateProvider);

  String get _storeId => arg.paymentParameter['store_id'];
  String get _storeKey => arg.paymentParameter['signature_key'];
  String get _isSand => arg.paymentParameter['is_sandbox'];

  final _module = "bends";

  Future<String?> payWithAamarPay(BuildContext context) async {
    if (_order == null) return 'Something went wrong, please try again';

    final config = AamarPayConfig(
      email: _order!.order.billingAddress?.email ?? '',
      mobile: _order!.order.billingAddress?.phone ?? '',
      name: _order!.order.billingAddress?.fullName,
      signature: _storeKey,
      storeID: _storeId,
      amount: _order!.paymentLog.finalAmount.toString(),
      transactionId: _order!.paymentLog.trx,
      description: 'Payment for order ${_order!.paymentLog.trx}',
      isSandBox: _isSand == '1',
    );
    // await _module(
    //   context,
    //   config: config,
    //   urlCallback: (status, url) async {
    //     Logger('$url ::  ${status.name}}', 'status');
    //
    //     if (status == "sucess") {
    //      // AamarPayStatus.success
    //       await _executePayment(context, 'success');
    //     }
    //     if (status == "falied") {
    //      // AamarPayStatus.failed
    //       await _executePayment(context, 'failed');
    //     }
    //   },
    //   eventCallback: (event, url) {
    //     Logger('$url ::  ${event.name}}', 'event');
    //   },
    // );
    return null;
  }

  Future<void> _executePayment(BuildContext context, String type) async {
    final body = {'currency': _order!.paymentLog.method.currency.name};

    final trx = _order!.paymentLog.trx;
    final callbackUrl = '${arg.callbackUrl}/$trx/$type';

    await PaymentRepo().confirmPayment(context, body, callbackUrl);
  }

  @override
  String build(PaymentData arg) {
    return '';
  }
}
