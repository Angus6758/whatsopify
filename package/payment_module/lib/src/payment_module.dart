import 'package:flutter/material.dart';
import 'package:payment_module/src/aamar_pay/aamar_pay.dart';

/// {@template payment_module}
/// A package to manage app payment methods for igen solution
/// {@endtemplate}
class PaymentModule {
  const PaymentModule();

  /// start payment with aamarPay
  Future<void> payWithAamarPay(
    BuildContext context, {
    required AamarPayConfig config,
    AAPUrlCallback? urlCallback,
    AAPEventCallback? eventCallback,
  }) async {
    AamarPayView.openPage(
      context,
      config: config,
      urlCallback: urlCallback,
      eventCallback: eventCallback,
    );
  }
}
