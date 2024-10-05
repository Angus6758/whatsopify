// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/payment_credentials/insta_mojo_credentials.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/routes/go_route_name.dart';

final instaMojoCtrlProvider =
    StateNotifierProvider.family<InstaMojoCtrlNotifier, String, PaymentData>(
        (ref, paymentData) {
  return InstaMojoCtrlNotifier(ref, paymentData);
});

class InstaMojoCtrlNotifier extends StateNotifier<String> {
  InstaMojoCtrlNotifier(this._ref, this.paymentData) : super('');

  final Ref _ref;
  final PaymentData paymentData;

  final _dio = Dio()..interceptors.add(talk.dioLogger);

  InstaMojoCredentials get _creds =>
      InstaMojoCredentials.fromMap(paymentData.paymentParameter);

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);

  String get _baseUrl => _creds.isSandbox
      ? 'https://test.instamojo.com/api/1.1'
      : 'https://www.instamojo.com/api/1.1';

  String get redirectUrl =>
      '${Endpoints.baseApiUrl}/instamojo/payment/callback';

  initializePayment(BuildContext context) async {
    try {
      final response = await _dio.request(
        "$_baseUrl/payment-requests/",
        options: Options(method: 'POST', headers: _headers()),
        data: FormData.fromMap(_paymentData()),
      );

      final body = response.data;

      final url = body['payment_request']['longurl'];
      RouteNames.instaMojoPayment.goNamed(context, extra: url);
    } on DioException catch (err) {
      final response = err.response?.data['message'] as Map<String, dynamic>;
      final msg =
          response.entries.first.value ?? TR.somethingWentWrong(context);
      Toaster.showError(msg);
    }
  }

  Map<String, String> _headers() {
    final header = {
      'X-Api-Key': _creds.apiKey,
      'X-Auth-Token': _creds.authToken,
    };
    return header;
  }

  Map<String, dynamic> _paymentData() {
    return {
      'amount': _order!.paymentLog.finalAmount.toString(),
      'purpose': 'Payment',
      'buyer_name': _order!.order.billingAddress!.firstName,
      'email': _order!.order.billingAddress!.email,
      'phone': _order!.order.billingAddress!.phone,
      'redirect_url': redirectUrl,
      'webhook': '${paymentData.callbackUrl}/${_order!.paymentLog.trx}',
      'allow_repeated_payments': 'false',
      'send_email': _creds.isSandbox ? 'false' : 'true',
      'send_sms': _creds.isSandbox ? 'false' : 'true',
    };
  }

  Future<dynamic> confirmPayment(BuildContext context, Uri? uri) async {
    if (uri == null) return;

    final status = uri.queryParameters['payment_status'];

    RouteNames.afterPayment.goNamed(
      context,
      query: {'status': status == 'Credit' ? 's' : 'f', 'method': 'Instamojo'},
    );
  }
}
