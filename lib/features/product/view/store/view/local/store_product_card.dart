
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/content/store_model.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/k_rating_bar.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../../_widgets/_widgets.dart';



class StoreProductCard extends ConsumerWidget {
  const StoreProductCard({
    super.key,
    required this.store,
    this.direction = Axis.horizontal,
  });

  final StoreModel store;
  final Axis direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHorizontal = direction == Axis.horizontal;
    return Container(
      width: isHorizontal ? 210 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colors.primaryContainer
                .withOpacity(context.isDark ? 0.3 : 0.1),
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0,
                    color: context.colors.secondary,
                  ),
                  color: Colors.white,
                  borderRadius: defaultRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: HostedImage(
                    store.storeLogo,
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isHorizontal ? 110 : 95,
                    child: Text(
                      store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    '${store.totalProducts} ${TR.products(context)}',
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colors.secondaryContainer,
                    ),
                  ),
                  KRatingBar(
                    rating: store.rating.toDouble(),
                    itemSize: 15,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  RouteNames.store.pushNamed(
                    context,
                    pathParams: {'id': '${store.storeId}'},
                  );
                },
                child: Text(
                  TR.visitStore(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
