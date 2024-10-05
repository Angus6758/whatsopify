
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/payment/payment_gateway/payment_gateway.dart';

class PayeerWebviewPage extends HookConsumerWidget {
  const PayeerWebviewPage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(
      checkoutStateProvider.select((value) => value?.paymentLog.method),
    );

    if (paymentMethod == null) {
      return ErrorView1.withScaffold('Failed to load CashMaal Information');
    }

    final payCtrl = useCallback(
        () => ref.read(payeerPaymentCtrlProvider(paymentMethod).notifier));

    final progress = useState<double?>(null);

    final webCtrl = useState<InAppWebViewController?>(null);

    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            shouldOverrideUrlLoading: (controller, action) async {
              final url = action.request.url;
              Logger(url, 'url');

              if (url.toString().contains(payCtrl().callbackUrl())) {
                await payCtrl().executePayment(context, url);
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
            ),
            onWebViewCreated: (controller) => webCtrl.value = controller,
            onProgressChanged: (controller, p) => progress.value = p / 100,
          ),
          LinearProgressIndicator(value: progress.value),
        ],
      ),
    );
  }
}
