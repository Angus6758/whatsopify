import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/withdraw/controller/withdraw_ctrl.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

class WithdrawConfirmDialog extends ConsumerWidget {
  const WithdrawConfirmDialog({
    super.key,
    required this.formData,
  });

  final QMap formData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawData = ref.watch(withdrawCtrlProvider);

    final extraData = formData.entries.where((e) => e.key != 'amount').toList();

    if (withdrawData == null) {
      return AlertDialog(
        title: const Text('Withdraw Request'),
        content: const Text('Something went wrong while requesting withdraw'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Ok'),
          ),
        ],
      );
    }

    Future<void> withdrawConfirm() async {
      final ctrl = ref.read(withdrawCtrlProvider.notifier);
      final data = <String, dynamic>{};
      for (var e in extraData) {
        data.addAll({e.key: e.value});
      }
      await ctrl.store('${withdrawData.id}', data);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      decoration: const BoxDecoration(
        borderRadius: Corners.medBorder,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WITHDRAW PREVIEW'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        bottomNavigationBar: SubmitButton(
          padding: Insets.padAll,
          onPressed: (l) async {
            l.value = true;
            await withdrawConfirm();
            l.value = false;

            if (context.mounted) RouteNames.withdraw.goNamed(context);
          },
          child: const Text('Withdraw'),
        ),
        body: SingleChildScrollView(
          padding: Insets.padAll,
          child: SeparatedColumn(
            separatorBuilder: () => const Gap(Insets.lg),
            children: [
              SpacedText(
                left: 'Withdraw Method',
                right: withdrawData.method.name,
                style: context.textTheme.bodyLarge,
              ),
              SpacedText(
                left: 'Withdraw Amount',
                right: withdrawData.amount.formate(useBase: true),
                style: context.textTheme.bodyLarge,
              ),
              SpacedText(
                left: 'Charge',
                right: withdrawData.charge.formate(useBase: true),
                style: context.textTheme.bodyLarge,
              ),
              SpacedText(
                left: 'Conversion rate',
                right:
                    '${withdrawData.currency.rate} ${withdrawData.currency.name}',
                style: context.textTheme.bodyLarge,
              ),
              const Divider(),
              SpacedText(
                left: 'Final Amount',
                right: withdrawData.finalAmount
                    .formate(currency: withdrawData.currency),
                style: context.textTheme.titleMedium,
                styleBuilder: (left, right) => (
                  left,
                  context.textTheme.titleLarge?.copyWith(
                    color: context.colorTheme.primary,
                  ),
                ),
              ),
              const Divider(),
              for (var MapEntry(:key, :value) in extraData)
                SpacedText(
                  left: withdrawData.method.inputLabelFromName(key),
                  right: value,
                  style: context.textTheme.bodyLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
