import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/main.export.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.displayMessage,
    this.title,
    this.onConfirm,
    this.popAfter = true,
  });

  final String? title;
  final String displayMessage;
  final dynamic Function()? onConfirm;
  final bool popAfter;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Lottie.asset(AssetsConst.warning, height: 80),
          const Gap(Insets.med),
          Text(
            title ?? 'Are you sure ?',
          ),
        ],
      ),
      content: Text(displayMessage),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        SubmitButton.dense(
          onPressed: (l) async {
            l.value = true;
            await onConfirm?.call();
            l.value = false;
            if (context.mounted && popAfter) context.pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
