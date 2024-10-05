
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/cart/controller/carts_ctrl.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/user_content/carts_model.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../../_widgets/_widgets.dart';

class CartTile extends HookConsumerWidget {
  const CartTile({
    super.key,
    required this.cart,
    this.onCartDelete,
  });

  final CartData cart;
  final Function(CartData cart)? onCartDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartsCtrl = useCallback(() => ref.read(cartCtrlProvider.notifier));
    final isLoggedIn = ref.watch(authCtrlProvider);
    final product = cart.product;

    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);

    final isLoading = useState(false);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => RouteNames.productDetails1.pushNamed(
                  context,
                  pathParams: {'id': product.uid},
                  query: {
                    'isRegular': 'true',
                    't': 'cart',
                  },
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: context.onMobile ? 90 : 180,
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: defaultRadius,
                            image: DecorationImage(
                              image:
                                  HostedImage.provider(product.featuredImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            product.name,
                            style: context.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: context.colors.secondaryContainer
                                  .withOpacity(0.08),
                              borderRadius: defaultRadius,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child:
                                Text(cart.variant, textAlign: TextAlign.center),
                          ),
                          Text(
                            product.category,
                            style: context.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    if (isLoggedIn)
                                      TextSpan(
                                        text: cart.variantPrice.formate(),
                                      )
                                    else
                                      TextSpan(
                                        text: cart.baseDiscount
                                            .formate(rateCheck: true),
                                      ),
                                  ],
                                ),
                                style: context.textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: borderColor),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        isLoading.value = true;
                        await cartsCtrl().deleteCart(context, cart.uid);
                        onCartDelete?.call(cart);
                        isLoading.value = false;
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: context.colors.secondaryContainer.withOpacity(
                            context.isDark ? 0.1 : 0.05,
                          ),
                        ),
                        child: Icon(
                          Icons.delete_rounded,
                          color: context.colors.error,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: context.colors.secondaryContainer.withOpacity(
                          context.isDark ? 0.1 : 0.05,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                isLoading.value = true;
                                final quantity = cart.quantity;
                                await cartsCtrl().updateQuantity(
                                  cart.uid,
                                  quantity - 1,
                                );
                                isLoading.value = false;
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: context.colors.surface,
                                ),
                                child: const Center(
                                  child: Icon(Icons.remove),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${cart.quantity}',
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () async {
                                isLoading.value = true;
                                final quantity = cart.quantity;
                                await cartsCtrl().updateQuantity(
                                  cart.uid,
                                  quantity + 1,
                                );
                                isLoading.value = false;
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: context.colors.surface,
                                ),
                                child: const Center(
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (isLoading.value)
          const Positioned.fill(
            child: BlurredLoading(),
          )
      ],
    );
  }
}
