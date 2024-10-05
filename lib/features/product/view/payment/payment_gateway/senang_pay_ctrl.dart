// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/payment/controller/payment_ctrl.dart';
import 'package:seller_management/features/product/view/payment/repository/payment_repo.dart';
import 'package:seller_management/features/product/view/payment_credentials/senang_pay_cred.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../_core/network/dio_client.dart';
import '../view/payment_pages/senang_pay_payment_page.dart';

final senangPayCtrlProvider = NotifierProviderFamily<SenangPayCtrlNotifier,
    Map<String, dynamic>, PaymentData>(SenangPayCtrlNotifier.new);

class SenangPayCtrlNotifier
    extends FamilyNotifier<Map<String, dynamic>, PaymentData> {
  @override
  Map<String, dynamic> build(PaymentData arg) {
    return {};
  }

  SenangPayCreds get _cred => SenangPayCreds.fromMap(arg.paymentParameter);

  Future<void> initializePayment(BuildContext context) async {
    try {
      final (url, data) = _createPaymentUrl();

      goToWBPage(context, SenangPayPaymentPage(url, data));

      Toaster.remove();
    } on DioException catch (e) {
      Toaster.showError('${e.response?.data ?? AppDefaults.defErrorMsg}');
    }
  }

  int get _finalAmount => _order!.paymentLog.finalAmount.round();

  Map<String, dynamic> _toHash() {
    final body = {
      'detail': 'Order for product id ${_order!.order.orderId}',
      'amount': _finalAmount.toString(),
      'order_id': _order!.paymentLog.trx,
    };
    return body;
  }

  Map<String, dynamic> _payload() {
    final bill = _order!.order.billingAddress;
    final body = {
      'name': bill?.fullName ?? 'no name',
      'email': bill?.email ?? 'nomail@gmail.com',
      'phone': bill?.phone ?? 'no phone',
      ..._toHash()
    };

    return body;
  }

  String _getHash() {
    final body = _toHash();
    final toBeHash = _cred.secret + body.values.join('');

    final hash = md5.convert(utf8.encode(toBeHash)).toString();

    return hash;
  }

  (String, String) _createPaymentUrl() {
    final paymentUrl =
        'https://sandbox.senangpay.my/payment/${_cred.merchantId}';

    final body = _payload();

    final data = {...body, 'hash': _getHash()};

    // String encodedParams = data.entries
    //     .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
    //     .join('&');

    return (paymentUrl, json.encode(data));
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    Logger(url, 'url');

    final body = url!.queryParameters;

    final trx = _order!.paymentLog.trx;
    final callbackUrl = '${arg.callbackUrl}/$trx';

    await PaymentRepo().confirmPayment(context, body, callbackUrl);
  }

  OrderBaseModel? get _order => ref.read(checkoutStateProvider);
}
