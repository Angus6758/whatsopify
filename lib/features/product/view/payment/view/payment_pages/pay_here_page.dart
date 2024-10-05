// import 'dart:convert';

// import 'package:e_com/core/core.dart';
// import 'package:e_com/feature/check_out/providers/provider.dart';
// import 'package:e_com/feature/payment/payment_gateway/payment_gateway.dart';
// import 'package:e_com/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class PayHereViewPage extends HookConsumerWidget {
//   const PayHereViewPage(this.url, this.data, {super.key});
//   final String url;
//   final String data;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final method =
//         ref.watch(checkoutStateProvider.select((v) => v?.paymentLog.method));

//     if (method == null) {
//       return ErrorView.withScaffold('Failed to load PayHere Information');
//     }

//     final ctrl =
//         useCallback(() => ref.read(payHereCtrlProvider(method).notifier));

//     final progress = useState<double?>(null);
//     final webCtrl = useState<InAppWebViewController?>(null);

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Colors.orange,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () => context.pop(),
//         ),
//         title: Text(
//           'PayHere Payment',
//           style: context.textTheme.titleLarge,
//         ),
//       ),
//       body: Stack(
//         children: [
//           InAppWebView(
//             initialUrlRequest: URLRequest(
//               url: Uri.parse(url),
//               method: 'POST',
//               body: utf8.encode(data),
//             ),
//             onProgressChanged: (controller, p) => progress.value = p / 100,
//             shouldOverrideUrlLoading: (controller, action) async {
//               final url = action.request.url;

//               if (url.toString().contains(ctrl().callback())) {
//                 await ctrl().executePayment(context, url);
//                 return NavigationActionPolicy.CANCEL;
//               }
//               return NavigationActionPolicy.ALLOW;
//             },
//             initialOptions: InAppWebViewGroupOptions(
//               crossPlatform: InAppWebViewOptions(
//                 useShouldOverrideUrlLoading: true,
//                 javaScriptCanOpenWindowsAutomatically: true,
//               ),
//             ),
//             onUpdateVisitedHistory: (controller, url, androidIsReload) {},
//             onWebViewCreated: (controller) => webCtrl.value = controller,
//             onCloseWindow: (controller) async {
//               await controller.clearCache();
//               await controller.clearFocus();
//             },
//           ),
//           LinearProgressIndicator(value: progress.value),
//         ],
//       ),
//     );
//   }
// }
