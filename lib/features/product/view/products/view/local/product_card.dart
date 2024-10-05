import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/cart/controller/carts_ctrl.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/strings/hero_tags.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../../_widgets/_widgets.dart';

class ProductCard extends HookConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.height = 160,
    this.width = 180,
    this.cId,
    required this.type,
  });

  final ProductsData product;
  final String? type;
  final double height;
  final double width;
  final String? cId;

  String percent() {
    num price = product.price;
    num discountPrice = product.discountAmount;
    if (price <= 0) return '0 %';
    final total = ((price - discountPrice) / price) * 100;

    final percentage = total.toInt();
    return '$percentage %';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final cartList = ref.watch(
          cartCtrlProvider.select((carts) => carts.valueOrNull?.listData),
        ) ??
        [];
    final bool isCart =
        cartList.any((element) => element.product.uid == product.uid);

    final availableVariant = useState<MapEntry<String, VariantPrice>?>((null));

    useEffect(
      () {
        final variantPrices = product.variantPrices.map(
          (k, v) => MapEntry(k, VariantPrice.fromMap(v)),
        );
        availableVariant.value =
            variantPrices.entries.firstWhereOrNull((e) => e.value.quantity > 0);
        return null;
      },
      [product.uid],
    );

    final price = availableVariant.value == null
        ? product.price
        : availableVariant.value!.value.price;

    final discountPrice = availableVariant.value == null
        ? product.discountAmount
        : availableVariant.value!.value.discount;
    final isDiscount = availableVariant.value == null
        ? product.isDiscounted
        : availableVariant.value!.value.isDiscounted;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colors.primaryContainer
                .withOpacity(context.isDark ? 0.3 : 0.04),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          RouteNames.productDetails.pushNamed(
            context,
            pathParams: {'id': product.uid},
            query: {
              'isRegular': 'true',
              if (type != null) 't': type!,
              if (cId != null) 'cid': cId!,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: defaultRadiusOnlyTop,
                  child: HeroWidget(
                    tag: HeroTags.productImgTag(product, type ?? ''),
                    child: HostedImage(
                      height: 160,
                      width: double.infinity,
                      product.featuredImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 0,
                  child: HeroWidget(
                    tag: HeroTags.iconTag(
                      product.uid.ifEmpty(DateTime.now().toString()),
                      type,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        print("Button clicked! Product ID: prodct cart");
                        isLoading.value = true;

                        await ref.read(cartCtrlProvider.notifier).addToCart(
                              product: product,
                              attribute: availableVariant.value?.key,
                              cUid: cId,
                            );
                        talk.debug("compaignid $cId");
                        isLoading.value = false;
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 10,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                          color: context.colors.secondaryContainer,
                        ),
                        child: isLoading.value
                            ? SizedBox.square(
                                dimension: 25,
                                child: CircularProgressIndicator(
                                  color: context.colors.onSecondary,
                                ),
                              )
                            : isCart
                                ? Icon(
                                    Icons.done,
                                    color: context.colors.onSecondary,
                                  )
                                : Icon(
                                    Icons.shopping_basket_rounded,
                                    color: context.colors.onSecondary,
                                    size: 25,
                                  ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
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
                              product.rating.avgRating.toStringAsFixed(1),
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.error,
                      borderRadius: defaultRadiusPercentage,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Text(
                        percent(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colors.onError,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  HeroWidget(
                    tag: HeroTags.productNameTag(product, type),
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.availableAny
                        ? TR.inStock(context)
                        : TR.stockOut(context),
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: product.availableAny
                          ? context.colors.errorContainer
                          : context.colors.error,
                    ),
                  ),
                  const SizedBox(height: 5),
                  HeroWidget(
                    tag: HeroTags.productPriceTag(product, type),
                    child: Text.rich(
                      TextSpan(
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                        children: [
                          if (isDiscount) ...[
                            TextSpan(
                              text: discountPrice.formate(),
                            ),
                            const TextSpan(text: '  '),
                          ],
                          TextSpan(
                            text: price.formate(),
                            style: isDiscount
                                ? context.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
