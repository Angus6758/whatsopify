import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

class NotActiveStore extends ConsumerWidget {
  const NotActiveStore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AssetsConst.storeNotActive,
              height: 250,
            ),
            Text(
              'Your shop is not active',
              style: context.textTheme.headlineSmall,
            ),
            Text('Please contact your admin',
                style: context.textTheme.titleLarge),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => RouteNames.createTicket.pushNamed(context),
              child: const Text('Create Ticket'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => RouteNames.home.go(context),
              child: const Text('Go Home'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
