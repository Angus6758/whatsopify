
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/payment/payment_gateway/payment_gateway.dart';

class PhonePyViewPage extends HookConsumerWidget {
  const PhonePyViewPage(this.url, {super.key});
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method =
        ref.watch(checkoutStateProvider.select((v) => v?.paymentLog.method));

    if (method == null) {
      return ErrorView1.withScaffold('Failed to load PhonePy Information');
    }

    final ctrl =
        useCallback(() => ref.read(phonePyCtrlProvider(method).notifier));

    final progress = useState<double?>(null);
    final webCtrl = useState<InAppWebViewController?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'PhonePy Payment',
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
            ),
            onProgressChanged: (controller, p) => progress.value = p / 100,
            shouldOverrideUrlLoading: (controller, action) async {
              final url = action.request.url;

              if (url.toString().contains(ctrl().callbackUrl())) {
                await ctrl().executePayment(context, url);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onWebViewCreated: (controller) => webCtrl.value = controller,
          ),
          LinearProgressIndicator(value: progress.value),
        ],
      ),
    );
  }
}
