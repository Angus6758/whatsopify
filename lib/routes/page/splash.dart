import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              AppDefaults.appName,
              style: context.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
