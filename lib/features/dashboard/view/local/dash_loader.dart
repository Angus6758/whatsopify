import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_management/main.export.dart';

class DashLoader extends ConsumerWidget {
  const DashLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: Insets.padH,
              child: Column(
                children: [
                  const Gap(Insets.offset),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: KShimmer.card(
                          height: 60,
                          width: 60,
                        ),
                      ),
                      const Gap(Insets.med),
                      KShimmer.card(
                        height: 60,
                        width: context.width / 1.35,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(Insets.med),
            Padding(
              padding: Insets.padH,
              child: Column(
                children: [
                  MasonryGridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => KShimmer.card(
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
            KShimmer.card(
              height: 200,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
