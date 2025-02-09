import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/payment/repository/payment_repo.dart';
import 'package:seller_management/features/product/view/payment_credentials/flutter_wave_credentials.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/routes/go_route_name.dart';

final flutterWaveCtrlProvider =
    StateNotifierProvider.family<FlutterWaveCtrlNotifier, String, PaymentData>(
        (ref, paymentData) {
  return FlutterWaveCtrlNotifier(ref, paymentData);
});

class FlutterWaveCtrlNotifier extends StateNotifier<String> {
  FlutterWaveCtrlNotifier(this._ref, this.paymentData) : super('');

  final Ref _ref;
  final PaymentData paymentData;

  FlutterWaveCredentials get _creds =>
      FlutterWaveCredentials.fromMap(paymentData.paymentParameter);

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);

  String get redirectUrl =>
      '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

  String get _baseUrl => _creds.isSandbox
      ? "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/"
      : "https://api.ravepay.co/v3/sdkcheckout";

  static const paymentUrl = "/payments";

  Future<void> initializePayment(BuildContext context) async {
    final dio = Dio()..interceptors.add(talk.dioLogger);

    final data = {
      "tx_ref": _order!.paymentLog.trx,
      "publicKey": _creds.publicKey,
      "amount": _order!.paymentLog.finalAmount.round().toString(),
      "currency": paymentData.currency.name,
      "payment_options": "ussd, card, barter, payattitude",
      "redirect_url": redirectUrl,
      "customizations": {
        "title": "Flutter Wave Payment",
      },
      'customer': {
        "email": _order!.order.billingAddress!.email,
        "phonenumber": _order!.order.billingAddress!.phone,
        "name": _order!.order.billingAddress!.fullName,
      }
    };

    final headers = {
      HttpHeaders.authorizationHeader: _creds.publicKey,
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final response = await dio.post(
      _baseUrl + paymentUrl,
      options: Options(headers: headers),
      data: data,
    );
    final body = response.data;

    if (response.statusCode != 200) return;

    if (body['status'] == 'error') return;
    if (!context.mounted) return;

    RouteNames.flutterWavePayment.goNamed(context, extra: body['data']['link']);
  }

  Future<void> confirmPayment(context, Uri? uri) async {
    final data = uri!.queryParameters;
    final callBack =
        '${paymentData.callbackUrl}/${data['tx_ref']}/${data['status']}';

    await PaymentRepo().confirmPayment(context, data, callBack);
  }
}
