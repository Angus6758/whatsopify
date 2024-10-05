import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class VoucherView extends ConsumerWidget {
  const VoucherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher'),
      ),
      body: Padding(
        padding: Insets.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(Insets.lg),
            Text(
              'Rules',
              style: context.textTheme.titleLarge,
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Join Campaign'),
              ),
            ),
            const Gap(100)
          ],
        ),
      ),
    );
  }
}
