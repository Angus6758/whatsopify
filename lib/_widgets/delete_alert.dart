import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/main.export.dart';

class DeleteAlert extends HookConsumerWidget {
  const DeleteAlert({
    super.key,
    required this.title,
    required this.onDelete,
    this.buttonText,
  });
  final String title;
  final String? buttonText;

  final Function() onDelete;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: SizedBox(
        height: context.height / 3,
        width: context.width * .7,
        child: Column(
          children: [
            const Gap(30),
            Lottie.asset(
              height: 100,
              AssetsConst.warning,
            ),
            const Gap(Insets.med),
            Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.nPop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const Gap(Insets.med),
                Expanded(
                  child: FilledButton(
                    onPressed: onDelete,
                    child: Text(buttonText ?? 'Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
