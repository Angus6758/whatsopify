
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/flash_deals/provider/flash_providers.dart';
import 'package:seller_management/features/product/view/home/view/local/counter_view.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/products/view/local/product_card.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

import '../../../../../_widgets/_widgets.dart';

class FlashDetailsView extends HookConsumerWidget {
  const FlashDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashDeal = ref.watch(flashDealProvider);
    if (flashDeal == null) return ErrorView1.withScaffold('No Flash Deal Found');

    return Scaffold(
      appBar: KAppBar(
        title: Text(
          flashDeal.name,
        ),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HostedImage(
              flashDeal.bannerImage,
              height: 180,
              width: double.infinity,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TR.flashProduct(context),
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 2,
                        width: context.width / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  FlashTimeCounter(
                    onlyTimer: true,
                    duration: flashDeal.endDate.difference(DateTime.now()),
                  )
                ],
              ),
            ),
            Padding(
              padding: defaultPadding.copyWith(top: 20),
              child: MasonryGridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: flashDeal.products.length,
                mainAxisSpacing: context.onMobile ? 10 : 30,
                crossAxisSpacing: context.onMobile ? 10 : 30,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.onMobile ? 2 : 4,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: flashDeal.products[index],
                    type: CachedKeys.flash,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
