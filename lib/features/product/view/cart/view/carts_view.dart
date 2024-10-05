import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/cart/controller/carts_ctrl.dart';
import 'package:seller_management/features/product/view/cart/view/local/cart_tile.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/list_view_with_footer.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/region_settings/controller/region_ctrl.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/spaced_text.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../_widgets/shimmer.dart';

class CartsView extends HookConsumerWidget {
  const CartsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authCtrlProvider);

    final cartList = ref.watch(cartCtrlProvider);
    final cartCtrl = useCallback(() => ref.read(cartCtrlProvider.notifier));
    final currency = ref.watch(regionCtrlProvider.select((v) => v.currency));

    final (minAmountDB, amountCheck) = ref.watch(
      settingsProvider.select(
        (v) {
          if (v == null) return (0, false);
          return (v.settings.minOrderAmount, v.settings.minOrderCheck);
        },
      ),
    );

    final minAmount = minAmountDB * (currency?.rate ?? 1);

    return cartList.when(
      error: (error, s) =>
          Scaffold(body: ErrorView1.reload(error, s, () => cartCtrl().reload())),
      loading: () => const CartLoading(),
      data: (carts) {
        num subTotal = carts.listData
            .map((e) => e.originalTotal)
            .sum
            .formateSelf(rateCheck: !isLoggedIn);

        final isDisable = amountCheck && subTotal < minAmount;

        final progress = ((subTotal / minAmount) * 100) / 100;

        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) return;
            RouteNames.home.goNamed(context);
          },
          child: Scaffold(
            appBar: KAppBar(
              title: Text(TR.shoppingCart(context)),
            ),
            bottomNavigationBar: BottomAppBar(
              height: amountCheck ? 150 : 120,
              padding: defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  SpacedText(
                    leftText: TR.subtotal(context),
                    rightText: subTotal.formate(),
                    style: context.textTheme.titleLarge,
                  ),
                  if (amountCheck) ...[
                    const SizedBox(height: 10),
                    if (subTotal < minAmount)
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Spend '),
                            TextSpan(
                              text: (minAmount - subTotal).formate(),
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                            const TextSpan(text: ' more to place order'),
                          ],
                        ),
                        style: context.textTheme.labelSmall,
                      ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                  const SizedBox(height: 5),
                  SubmitButton(
                    onPressed: isDisable || subTotal <= 0
                        ? null
                        : () => RouteNames.shippingDetails.goNamed(context),
                    child: Text(
                      TR.submitOrder(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            body: Padding(
              padding: defaultPadding,
              child: RefreshIndicator(
                onRefresh: () => cartCtrl().reload(),
                child: ListViewWithFooter(
                  pagination: carts.pagination,
                  onNext: () => cartCtrl().paginationHandler(true),
                  onPrevious: () => cartCtrl().paginationHandler(false),
                  physics: defaultScrollPhysics,
                  itemCount: carts.length,
                  emptyListWidget:
                      const Center(child: NoItemsAnimationWithFooter()),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CartTile(cart: carts.listData[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CartLoading extends ConsumerWidget {
  const CartLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: defaultPaddingAll,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KShimmer.card(height: 100, width: 100),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: .9,
                        child: KShimmer.card(height: 25),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: .7,
                        child: KShimmer.card(height: 25),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: .6,
                        child: KShimmer.card(height: 25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
