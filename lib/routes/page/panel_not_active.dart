import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/main.export.dart';

class PanelInactive extends ConsumerWidget {
  const PanelInactive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AssetsConst.panelNotActive,
              height: 250,
            ),
            Text(
              'Seller Panel Is Currently Inactive',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Please contact your admin',
              style: context.textTheme.titleLarge,
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                  ),
                  onPressed: () async {
                    final statusCtrl = ref.read(serverStatusProvider.notifier);

                    await statusCtrl.retryStatusResolver();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                  ),
                  onPressed: () => exit(0),
                  icon: const Icon(Icons.exit_to_app_rounded),
                  label: const Text('Exit'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
