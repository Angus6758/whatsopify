import 'package:flutter/material.dart';
import 'package:payment_module/src/aamar_pay/aamar_pay_config.dart';
import 'package:payment_module/src/aamar_pay/aamar_pay_repo.dart';
import 'package:payment_module/src/aamar_pay/aamar_pay_wb.dart';

enum AamarPayStatus { success, cancel, failed }

enum EventState { success, fail, cancel, error, backButtonPressed }

typedef AAPUrlCallback = void Function(AamarPayStatus status, String url);
typedef AAPEventCallback = void Function(EventState event, String msg);

class AamarPayView extends StatefulWidget {
  const AamarPayView({
    required this.config,
    this.urlCallback,
    this.eventCallback,
    super.key,
  });

  final AamarPayConfig config;

  final AAPUrlCallback? urlCallback;

  final AAPEventCallback? eventCallback;

  /// open aamarPay payment page
  static void openPage(
    BuildContext context, {
    required AamarPayConfig config,
    AAPUrlCallback? urlCallback,
    AAPEventCallback? eventCallback,
  }) {
    final route = MaterialPageRoute<dynamic>(
      builder: (c) => AamarPayView(
        config: config,
        urlCallback: urlCallback,
        eventCallback: eventCallback,
      ),
    );

    Navigator.of(context).push(route);
  }

  @override
  State<AamarPayView> createState() => _AmarPayViewState();
}

class _AmarPayViewState extends State<AamarPayView> {
  String? payUrl;
  bool isLoading = true;

  AamarPayRepo get _repo => AamarPayRepo(config: widget.config);

  void _eventHandler(EventState event, String msg) {
    widget.eventCallback?.call(event, msg);
  }

  void _urlHandler(AamarPayStatus status, String url) {
    widget.urlCallback?.call(status, url);
  }

  Future<void> _getUrl() async {
    try {
      payUrl = await _repo.getPaymentUrl();
      isLoading = false;
      setState(() {});
    } catch (e) {
      _urlHandler(AamarPayStatus.failed, 'ex');
      _eventHandler(EventState.error, e.toString());
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          _eventHandler(
            EventState.backButtonPressed,
            'Payment has been canceled by user',
          );
          _urlHandler(AamarPayStatus.cancel, '');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: const Text('Aamar Pay Payment'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (payUrl != null && !isLoading)
                  Expanded(
                    child: AamarPayWebviewPage(
                      payUrl!,
                      successUrl: _repo.successUrl,
                      failUrl: _repo.failUrl,
                      cancelUrl: _repo.cancelUrl,
                      urlCallback: (status, url) {
                        _urlHandler(status, url);
                        if (status == AamarPayStatus.success) {
                          _eventHandler(EventState.success, 'Success');
                        }
                        if (status == AamarPayStatus.failed) {
                          _eventHandler(EventState.fail, 'Failed');
                        }
                        if (status == AamarPayStatus.cancel) {
                          _eventHandler(EventState.cancel, 'Canceled');
                        }
                      },
                    ),
                  ),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
