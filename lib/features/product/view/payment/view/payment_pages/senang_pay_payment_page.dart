import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/payment/payment_gateway/senang_pay_ctrl.dart';

class SenangPayPaymentPage extends HookConsumerWidget {
  const SenangPayPaymentPage(this.url, this.body, {super.key});

  final String body;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method =
        ref.watch(checkoutStateProvider.select((v) => v?.paymentLog.method));

    if (method == null) {
      return ErrorView1.withScaffold('Failed to load Paystack Information');
    }

    final ctrl =
        useCallback(() => ref.read(senangPayCtrlProvider(method).notifier));

    final progress = useState<double?>(null);
    final webCtrl = useState<InAppWebViewController?>(null);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.nPop(),
        ),
        title: Text(
          'SenangPay Payment',
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
            ),
            initialUrlRequest: URLRequest(
              url: WebUri(url),
              method: 'POST',
              body: utf8.encode(body),
            ),
            onProgressChanged: (controller, p) => progress.value = p / 100,
            onLoadStart: (controller, url) {
              Logger(url.toString(), 'url');
            },
            onLoadStop: (controller, url) async {
              if (url.toString().contains('payment_success')) {
                await ctrl().executePayment(context, url);
              } else if (url.toString().contains('payment_failed')) {
                await ctrl().executePayment(context, url);
              }
            },
            onWebViewCreated: (controller) => webCtrl.value = controller,
          ),
          LinearProgressIndicator(value: progress.value),
        ],
      ),
    );
  }
}
