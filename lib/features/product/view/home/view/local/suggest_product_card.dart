
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../../_widgets/_widgets.dart';

class SuggestProductCard extends ConsumerWidget {
  const SuggestProductCard({
    super.key,
    required this.product,
    this.cId,
  });
  final ProductsData product;
  final String? cId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          RouteNames.productDetails.pushNamed(
            context,
            pathParams: {'id': product.uid},
            query: {
              'isRegular': 'true',
              't': 'suggest',
              if (cId != null) 'cid': cId!,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            color: context.colors.surface,
            border: Border.all(
              width: 0,
              color: context.colors.secondary,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: context.onMobile ? 3 : 2,
                child: Padding(
                  padding: defaultPaddingAll,
                  child: ClipRRect(
                    borderRadius: defaultRadius,
                    child: HostedImage(
                      product.featuredImage,
                      fit: BoxFit.cover,
                      height: 85,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Container(
                  height: context.height,
                  width: 1,
                  color: context.colors.secondaryContainer.withOpacity(0.03),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name * 5,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.availableAny
                          ? "brands"
                          : "brands",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: product.availableAny
                            ? context.colors.errorContainer
                            : context.colors.error,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      children: [
                        if (product.isDiscounted)
                          Text(
                            product.discountAmount.formate(),
                            style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colors.error,
                            ),
                          ),
                        if (product.isDiscounted) const SizedBox(width: 5),
                        Text(
                          product.price.formate(),
                          style: product.isDiscounted
                              ? context.textTheme.bodyMedium?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.error,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 15,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      product.rating.avgRating.toString(),
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
