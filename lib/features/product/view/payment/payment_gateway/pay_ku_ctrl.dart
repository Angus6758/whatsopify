// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/payment/controller/payment_ctrl.dart';
import 'package:seller_management/features/product/view/payment_credentials/pay_ku_creds.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../view/payment_pages/payment_pages.dart';

final payKuCtrlProvider =
    NotifierProviderFamily<PayKyCtrlNotifier, String, PaymentData>(
        PayKyCtrlNotifier.new);

class PayKyCtrlNotifier extends FamilyNotifier<String, PaymentData> {
  @override
  String build(PaymentData arg) {
    return '';
  }

  Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

  String callback([String type = '']) => 'https://callback.com/payment/$type';

  PayKuCreds get _cred => PayKuCreds.fromMap(arg.paymentParameter);

  Future<void> initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting...');
      final data = await createPayment();
      final url = data['url'];
      state = data['id'];

      goToWBPage(context, PayKuWebViewPage(url));
    } on DioException catch (e) {
      Toaster.showError('${e.response?.data ?? AppDefaults.defErrorMsg}');
    } catch (e) {
      Toaster.showError(e.toString());
    }
    Toaster.remove();
  }

  int get _finalAmount => _order!.paymentLog.finalAmount.round();

  Future<String> _payload() async {
    final bill = _order!.order.billingAddress;
    var trx = _order!.paymentLog.trx;
    final body = {
      "email": bill?.email ?? 'nomail@gmail.com',
      "order": trx,
      "subject": "Payment for order ${_order!.order.orderId}",
      "amount": _finalAmount.toString(),
      "currency": _order!.paymentLog.method.currency.name,
      "payment": 1,
      "urlreturn": callback(),
      "urlnotify": '${arg.callbackUrl}/$trx',
    };

    return json.encode(body);
  }

  Future<Map<String, dynamic>> createPayment() async {
    final api = _cred.isSandBox
        ? 'https://des.payku.cl/api/transaction'
        : 'https://app.payku.cl/api/transaction';
    final option = Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_cred.publicToken}',
      },
    );

    final response =
        await _dio.post(api, data: await _payload(), options: option);

    Logger.json(response.data, 'create');

    return response.data;
  }

  OrderBaseModel? get _order => ref.read(checkoutStateProvider);
}
