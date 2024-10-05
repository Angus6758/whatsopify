// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/payment/repository/payment_repo.dart';
import 'package:seller_management/features/product/view/payment_credentials/esewa_credentials.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final eSewaPaymentCtrlProvider = AutoDisposeNotifierProviderFamily<
    ESewaPaymentCtrlNotifier,
    String,
    PaymentData>(ESewaPaymentCtrlNotifier.new);

class ESewaPaymentCtrlNotifier
    extends AutoDisposeFamilyNotifier<String, PaymentData> {
  String getProductName() {
    final details = _order!.order.orderDetails.firstOrNull;
    return details?.product?.name ??
        details?.digitalProduct?.name ??
        _order!.paymentLog.trx;
  }

  Future<void> initiatePayment(BuildContext context) async {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: _creds.isSandbox ? Environment.test : Environment.live,
          clientId: _creds.clientId,
          secretId: _creds.clientSecret,
        ),
        esewaPayment: EsewaPayment(
          productId: _order!.paymentLog.trx,
          productName: getProductName(),
          productPrice: _order!.paymentLog.finalAmount.toString(),
          callbackUrl: Endpoints.baseApiUrl,
        ),
        onPaymentSuccess: (data) async {
          Logger.json(data.toJson(), 'success');
          Toaster.showInfo('please wait ...');
          await onPaymentSuccess(data, context);
        },
        onPaymentFailure: (data) async {
          Logger(":::FAILURE::: => $data");
          Toaster.showInfo('please wait ...');
          await _confirm(context);
        },
        onPaymentCancellation: (data) async {
          Logger(":::CANCELLATION::: => $data");
        },
      );
    } catch (e, s) {
      talk.ex(e, s);
    }
  }

  Future<void> onPaymentSuccess(
    EsewaPaymentSuccessResult data,
    BuildContext context,
  ) async {
    final jsonData = {"status": data.status};
    await _confirm(context, jsonData);
  }

  ESewaCredentials get _creds => ESewaCredentials.fromMap(arg.paymentParameter);

  OrderBaseModel? get _order => ref.read(checkoutStateProvider);

  Future<void> _confirm(
    BuildContext context, [
    Map<String, String>? data,
  ]) async {
    final trx = _order!.paymentLog.trx;
    final status = data == null ? 'failed' : 'success';

    String callback = '${arg.callbackUrl}/$trx/$status';

    String encodedData = base64Encode(utf8.encode(jsonEncode(data)));

    await PaymentRepo()
        .confirmPayment(context, {'data': encodedData}, callback);
  }

  @override
  String build(PaymentData arg) {
    return '';
  }
}


//KBIXHAQHS0saCh5FWQ8DUSspSDY2WiwyOS48MV4mOCw=
//FhcOWQwSGQ4cEQ==
//KBIXHAQHS0saCh5FWQ8DUSspSDY2WiwyOS48MV4mOCw=