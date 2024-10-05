// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/payment/controller/payment_ctrl.dart';
import 'package:seller_management/features/product/view/payment/repository/payment_repo.dart';
import 'package:seller_management/features/product/view/payment_credentials/n_genius_creds.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';

import '../view/payment_pages/n_genius_payment_page.dart';

final nGeniusCtrlProvider = NotifierProviderFamily<NGeniusCtrlNotifier,
    Map<String, dynamic>, PaymentData>(NGeniusCtrlNotifier.new);

class NGeniusCtrlNotifier
    extends FamilyNotifier<Map<String, dynamic>, PaymentData> {
  String callback([String type = '']) => 'https://callback.com/payment/$type';

  Future<void> initializePayment(BuildContext context) async {
    Toaster.showLoading('Redirecting...');

    final payData = await _createPayment();
    final url = payData?['_links']?['payment']?['href'];
    state = {'ref': payData?['reference']};
    if (url is! String) {
      Toaster.showError('Payment Url Not Found');
      return;
    }

    goToWBPage(context, NGeniusPaymentPage(url));

    Toaster.remove();
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    Logger(url, 'url');

    final trx = _order!.paymentLog.trx;
    final callbackUrl = '${arg.callbackUrl}/$trx';

    Logger.json(state);

    await PaymentRepo().confirmPayment(context, state, callbackUrl);
  }

  Future<Map<String, dynamic>?> _createPayment() async {
    final token = await _getAccessToken();
    if (token == null) {
      Toaster.showError('Token Not Found');
      return null;
    }
    final outRef = _cred.outletId;
    final api =
        'https://api-gateway-uat.ngenius-payments.com/transactions/outlets/$outRef/payment/card';

    final bearerAuth = 'Bearer $token';

    final option = Options(
      headers: {
        'Authorization': bearerAuth,
        'Content-Type': 'application/vnd.ni-payment.v2+json',
        'Accept': 'application/vnd.ni-payment.v2+json',
      },
    );

    final response = await _dio.post(api, data: _payload(), options: option);

    Logger.json(response.data, 'response');

    return response.data;
  }

  Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

  NGeniusCreds get _cred => NGeniusCreds.fromMap(arg.paymentParameter);

  int get _finalAmount => _order!.paymentLog.finalAmount.round();

  Map<String, dynamic> _payload() {
    final bill = _order!.order.billingAddress;
    final body = {
      'order': {
        'action': 'SALE',
        'amount': {
          'currencyCode': _order!.paymentLog.method.currency.name,
          'value': _finalAmount,
        },
        'emailAddress': bill?.email ?? 'noemail@gmail.com',
        'merchantAttributes': {
          'redirectUrl': callback(),
          'cancelUrl': callback(),
        },
        'merchantOrderReference': _order!.paymentLog.trx,
        'billingAddress': {
          'firstName': bill?.firstName ?? '',
          'lastName': bill?.lastName ?? '',
          'address1': bill?.address ?? '',
          'city': bill?.city ?? '',
          'countryCode': 'AE',
        }
      },
    };

    return body;
  }

  Future<String?> _getAccessToken() async {
    try {
      const api =
          'https://api-gateway-uat.ngenius-payments.com/identity/auth/access-token';

      final option = Options(
        headers: {
          'Authorization': 'Basic ${_cred.apiKey}',
          'Content-Type': 'application/vnd.ni-identity.v1+json',
        },
      );

      final response = await _dio.post(api, options: option);
      final data = response.data?['access_token'];

      return data?.toString();
    } catch (e) {
      return null;
    }
  }

  OrderBaseModel? get _order => ref.read(checkoutStateProvider);

  @override
  Map<String, dynamic> build(PaymentData arg) {
    return {};
  }
}
