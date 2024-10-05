import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payment_module/payment_module.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/check_out/repository/checkout_repo.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/payment/payment_gateway/esewa_payment_ctrl.dart';
import 'package:seller_management/features/product/view/payment/payment_gateway/payment_gateway.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:seller_management/routes/go_route_name.dart';
import 'package:url_launcher/url_launcher_string.dart';

final paymentCtrlProvider =
    StateNotifierProvider<PaymentCtrl, PaymentData?>((ref) {
  return PaymentCtrl(ref);
});

class PaymentCtrl extends StateNotifier<PaymentData?> {
  PaymentCtrl(this._ref) : super(null);

  final Ref _ref;

  Future<bool> _setPaymentLog(
    String orderUid,
    PaymentData method,
    Function(String trx)? onUrlLaunch,
  ) async {
    final repo = _ref.read(checkoutRepoProvider);
    final res = await repo.getPaymentLog(orderUid, method.id);
    final pref = _ref.read(sharedPrefProvider);
    return await res.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) async {
        if (r.data.paymentUrl != null) {
          await launchUrlString(r.data.paymentUrl!);
          onUrlLaunch?.call(r.data.paymentLog.trx);
          return false;
        }
        return await pref.setString(CachedKeys.orderBase, r.data.toJson());
      },
    );
  }

  Future<void> payNow(
    BuildContext context,
    String orderUid,
    PaymentData method,
  ) async {
    Toaster.showLoading('Loading...');
    final didSetLog = await _setPaymentLog(
      orderUid,
      method,
      (id) => RouteNames.afterPayment
          .goNamed(context, query: {'status': 'w', 'id': id}),
    );
    Toaster.remove();

    if (!didSetLog || !context.mounted) return;

    RouteNames.orderPlaced.pushNamed(context, query: {'from': 'payNow'});
  }

  Future<void> initializePaymentWithMethod(
    BuildContext context, {
    PaymentData? method,
  }) async {
    if (_order == null) {
      Toaster.showError(TR.somethingWentWrong(context));
      return;
    }

    if (method == null) {
      Toaster.showError(TR.somethingWentWrong(context));
      return;
    }

    state = method;
    final paymentMethod = PaymentMethod.fromName(state?.name);
    Logger.json(state?.toMap());
    Logger.json(_order!.paymentLog.trx);

    final res = await switch (paymentMethod) {
      PaymentMethod.stripe => _payWithStripe(context),
      PaymentMethod.paypal => _payWithPaypal(context),
      PaymentMethod.payStack => _payWithPayStack(context),
      PaymentMethod.flutterWave => _payWithFlutterWave(context),
      PaymentMethod.razorPay => _payWithRazorPay(context),
      PaymentMethod.instaMojo => _payWithInstaMojo(context),
      PaymentMethod.bkash => _payWithBkash(context),
      PaymentMethod.nagad => _payWithNagad(context),
      PaymentMethod.mercado => _payWithMercado(context),
      PaymentMethod.payeer => _payWithPayeer(context),
      PaymentMethod.aamarPay => _payWithAamarPay(context),
      PaymentMethod.payUMoney => _payWithPayUMoney(context),
      PaymentMethod.phonePe => _payWithPhonePy(context),
      PaymentMethod.payHere => _payWithPayHere(context),
      PaymentMethod.payKu => _payWithPayKu(context),
      PaymentMethod.senangPay => _payWithSenangPay(context),
      PaymentMethod.nGenius => _payWithNGenius(context),
      PaymentMethod.esewa => _payWithEsewa(context),
      null => Future(() => 'Unsupported Payment Method'),
    };
    if (res != null) Toaster.showInfo(res);
  }

  Future<String> _payWithEsewa(BuildContext context) async {
    final stripeCtrl = _ref.read(eSewaPaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initiatePayment(context);
    return '';
  }

  Future<String?> _payWithNGenius(BuildContext context) async {
    final ctrl = _ref.read(nGeniusCtrlProvider(state!).notifier);
    ctrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithSenangPay(BuildContext context) async {
    final ctrl = _ref.read(senangPayCtrlProvider(state!).notifier);
    ctrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPayKu(BuildContext context) async {
    final ctrl = _ref.read(payKuCtrlProvider(state!).notifier);
    ctrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPhonePy(BuildContext context) async {
    final ctrl = _ref.read(phonePyCtrlProvider(state!).notifier);
    ctrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPayHere(BuildContext context) async {
    // final ctrl = _ref.read(payHereCtrlProvider(state!).notifier);
    // ctrl.initializePayment(context);
    return 'Pay Here is not supported on this platform';
  }

  Future<String?> _payWithPayUMoney(BuildContext context) async {
    // final ctrl = _ref.read(payUPaymentCtrlProvider(state!).notifier);
    // ctrl.initializePayment(context);
    return 'Pay U Money is not supported on this platform';
  }

  Future<String?> _payWithStripe(BuildContext context) async {
    final stripeCtrl = _ref.read(stripePaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initializePaymentWEB(context);
    return null;
  }

  Future<String?> _payWithAamarPay(BuildContext context) async {
    return _ref
        .read(aamarPayCtrlProvider(state!).notifier)
        .payWithAamarPay(context);
  }

  Future<String?> _payWithPayeer(BuildContext context) async {
    final stripeCtrl = _ref.read(payeerPaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithMercado(BuildContext context) async {
    final stripeCtrl = _ref.read(mercadoPaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPaypal(BuildContext context) async {
    final paypalCtrl = _ref.read(paypalPaymentCtrlProvider(state!).notifier);
    await paypalCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPayStack(BuildContext context) async {
    final payStackCtrl = _ref.read(paystackCtrlProvider(state!).notifier);
    await payStackCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithFlutterWave(BuildContext context) async {
    await _ref
        .read(flutterWaveCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithRazorPay(BuildContext context) async {
    await _ref
        .read(razorPayPaymentCtrlProvider((state!)))
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithInstaMojo(BuildContext context) async {
    await _ref
        .read(instaMojoCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithBkash(BuildContext context) async {
    await _ref
        .read(bkashPaymentCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithNagad(BuildContext context) async {
    await _ref
        .read(nagadPaymentCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  OrderBaseModel? get _order => _ref.read(checkoutStateProvider);
}

void goToWBPage(BuildContext context, Widget page) {
  final route = MaterialPageRoute(builder: (c) => page);
  Navigator.push(context, route);
}
