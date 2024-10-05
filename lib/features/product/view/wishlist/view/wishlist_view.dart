

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/cart/view/carts_view.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/wishlist/controller/wishlist_ctrl.dart';
import 'package:seller_management/features/product/view/wishlist/view/wishlist_tile.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../_widgets/_widgets.dart';

class WishListView extends HookConsumerWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlists = ref.watch(wishlistCtrlProvider);
    final wishlistCtrl =
        useCallback(() => ref.read(wishlistCtrlProvider.notifier));

    return Scaffold(
      appBar: KAppBar(
        title: Text(TR.wishlist(context)),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          RouteNames.home.goNamed(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: wishlists.when(
            error: (e, s) =>
                ErrorView1.reload(e, s, () => wishlistCtrl().reload()),
            loading: () => const CartLoading(),
            data: (wishlist) {
              return RefreshIndicator(
                onRefresh: () => wishlistCtrl().reload(),
                child: ListViewWithFooter(
                  // pagination: wishlist.pagination,
                  // onNext: () => wishlistCtrl().paginationHandler(true),
                  // onPrevious: () => wishlistCtrl().paginationHandler(false),
                  physics: defaultScrollPhysics,
                  itemCount: wishlist.length,
                  emptyListWidget:
                      const Center(child: NoItemsAnimationWithFooter()),
                  itemBuilder: (BuildContext context, int index) {
                    final product = wishlist.listData[index].product;
                    return WishlistTile(
                      product: product,
                      onDelete: () async {
                        await wishlistCtrl()
                            .deleteWishlist(wishlist.listData[index].uid);
                      },
                      onTap: () => RouteNames.productDetails.goNamed(
                        context,
                        pathParams: {'id': product.uid},
                        query: {'isRegular': 'true', 'wish': 'true'},
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
