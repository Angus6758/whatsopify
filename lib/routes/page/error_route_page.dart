import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

class ErrorRoutePage extends StatelessWidget {
  const ErrorRoutePage({super.key, this.error});
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 5),
            Text(
              'Something went wrong',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              '$error',
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => RouteNames.home.goNamed(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
