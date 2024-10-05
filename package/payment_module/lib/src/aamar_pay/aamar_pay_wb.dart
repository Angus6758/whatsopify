import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:payment_module/payment_module.dart';

class AamarPayWebviewPage extends StatefulWidget {
  const AamarPayWebviewPage(
    this.url, {
    required this.successUrl,
    required this.failUrl,
    required this.cancelUrl,
    required this.urlCallback,
    super.key,
  });
  final String url;
  final String successUrl;
  final String failUrl;
  final String cancelUrl;
  final AAPUrlCallback urlCallback;

  @override
  State<AamarPayWebviewPage> createState() => _AamarPayWebviewPageState();
}

class _AamarPayWebviewPageState extends State<AamarPayWebviewPage> {
  double progress = 0.0;
  bool showBlank = false;

  void toggleBlank() => setState(() => showBlank = !showBlank);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          onProgressChanged: (controller, p) {
            progress = p / 100;
          },
          shouldOverrideUrlLoading: (controller, action) async {
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStart: (controller, uri) {
            final url = uri.toString();

            if (url.contains(widget.successUrl)) {
              toggleBlank();
              widget.urlCallback(AamarPayStatus.success, url);
            }

            if (url.contains(widget.cancelUrl)) {
              toggleBlank();
              widget.urlCallback(AamarPayStatus.cancel, url);
            }

            if (url.contains(widget.failUrl)) {
              toggleBlank();
              widget.urlCallback(AamarPayStatus.failed, url);
            }
          },
          initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            useOnDownloadStart: true,
            javaScriptCanOpenWindowsAutomatically: true,
          ),
          onCloseWindow: (controller) async {},
        ),
        if (progress < 1) LinearProgressIndicator(value: progress),
        if (showBlank)
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
      ],
    );
  }
}

String prettyJSON(response) {
  try {
    var encoder = const JsonEncoder.withIndent("  ");
    return encoder.convert(response);
  } catch (e) {
    return response;
  }
}
