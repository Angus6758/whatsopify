import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_management/main.export.dart';

class PlanLoader extends ConsumerWidget {
  const PlanLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            KShimmer.card(
              height: 150,
              width: double.infinity,
            ),
            Padding(
              padding: Insets.padH,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: KShimmer.card(
                        height: 120,
                        width: double.infinity,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanUpdateLoader extends ConsumerWidget {
  const PlanUpdateLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: Insets.padH.copyWith(top: 10),
      child: MasonryGridView.builder(
        shrinkWrap: true,
        itemCount: 10,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) => KShimmer.card(
          height: 150,
        ),
      ),
    );
  }
}
