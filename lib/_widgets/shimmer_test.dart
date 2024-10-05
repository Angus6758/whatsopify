import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class ShimmerTest extends ConsumerWidget {
  const ShimmerTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Insets.padH,
          child: Column(
            children: [
              const Gap(Insets.offset),
              KShimmer.card(
                height: 60,
                width: double.infinity,
              ),
              const Gap(Insets.med),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) => KShimmer(
                  child: Padding(
                    padding: Insets.padAll,
                    child: KShimmer.card(
                      height: 35,
                      width: double.infinity,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
