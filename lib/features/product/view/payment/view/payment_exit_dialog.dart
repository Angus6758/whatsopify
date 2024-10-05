
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';

class ExitPaymentDialog extends StatelessWidget {
  const ExitPaymentDialog({super.key});

  static onPaymentExit(
    BuildContext context, {
    InAppWebViewController? webCtrl,
    bool withDialog = true,
  }) async {
    final popped = await showDialog<bool>(
      context: context,
      builder: (_) => const ExitPaymentDialog(),
    );
    if (popped == null || !popped) return;

    webCtrl?.clearFocus();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(TR.exitPayment(context)),
      content: Text(TR.areYouSure(context)),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          child: Text(TR.yes(context)),
        ),
        TextButton(
          onPressed: () => context.pop<bool>(false),
          child: Text(TR.no(context)),
        ),
      ],
    );
  }
}
