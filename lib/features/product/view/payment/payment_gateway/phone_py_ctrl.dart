// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/payment/controller/payment_ctrl.dart';
import 'package:seller_management/features/product/view/payment/view/payment_pages/phone_py_wb_view.dart';
import 'package:seller_management/features/product/view/payment_credentials/phone_py_cred.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

final phonePyCtrlProvider =
    NotifierProviderFamily<PhonePyCtrlNotifier, String, PaymentData>(
        PhonePyCtrlNotifier.new);

class PhonePyCtrlNotifier extends FamilyNotifier<String, PaymentData> {
  @override
  String build(PaymentData arg) {
    return '';
  }

  Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

  String callbackUrl() => 'https://phonepycallback.com/payment/callback';

  PhonePyCreds get _cred => PhonePyCreds.fromMap(arg.paymentParameter);

  Future<void> initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting...');
      final paymentData = await createPayment();

      final url =
          paymentData['data']?['instrumentResponse']?['redirectInfo']?['url'];

      if (url == null) {
        Toaster.showError(paymentData['message'] ?? AppDefaults.defErrorMsg);
        return;
      }

      goToWBPage(context, PhonePyViewPage(url));

      Toaster.remove();
    } on DioException catch (e) {
      Toaster.showError(e.response?.data);
    }
  }

  int get _finalAmount => _order!.paymentLog.finalAmount.round();

  String _payload() {
    final body = {
      "merchantId": _cred.merchantId,
      "merchantUserId": _order!.paymentLog.trx,
      "merchantTransactionId": _order!.paymentLog.trx,
      "amount": _finalAmount,
      "redirectUrl": callbackUrl(),
      "redirectMode": "REDIRECT",
      "callbackUrl": '${arg.callbackUrl}/${_order!.paymentLog.trx}',
      "mobileNumber": _order!.order.billingAddress?.phone,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    return base64.encode(utf8.encode(jsonEncode(body)));
  }

  Future<Map<String, dynamic>> createPayment() async {
    const api = 'https://api.phonepe.com/apis/hermes/pg/v1/pay';

    final option = Options(
      headers: {
        HttpHeaders.acceptHeader: 'text/plain',
        'Content-Type': 'application/json',
        'X-VERIFY': await _getXVerify(),
      },
    );

    final response = await _dio.post(api, data: _payload(), options: option);

    Logger.json(response.data, 'create');

    return response.data;
  }

  Future<String> _getXVerify() async {
    String code = '${_payload()}/pg/v1/pay${_cred.salt}';
    final encoded = sha256.convert(utf8.encode(code));

    final xCode = '$encoded###${_cred.saltIndex}';
    Logger(xCode, 'xcode');
    return xCode;
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    RouteNames.afterPayment.goNamed(
      context,
      query: {'status': 'w'},
    );
  }

  OrderBaseModel? get _order => ref.read(checkoutStateProvider);
}
