
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/brands/controller/brand_controller.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/products/view/local/product_card.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../_widgets/_widgets.dart';

class BrandProductsView extends ConsumerWidget {
  const BrandProductsView(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandData = ref.watch(brandCtrlProvider(id));
    final brandCtrl = ref.read(brandCtrlProvider(id).notifier);

    return brandData.when(
      error: (e, s) => ErrorView1.reload(e, s, () => brandCtrl.reload()),
      loading: () => Loader1.withScaffold("brands"),
      data: (brand) {
        return Scaffold(
          appBar: KAppBar(
            title: Text(brand.brand.name),
            leading: SquareButton.backButton(
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: defaultPadding.copyWith(top: 20),
            child: brand.products.isEmpty
                ? const Center(child: NoItemsAnimation())
                : RefreshIndicator(
                    onRefresh: () => brandCtrl.reload(),
                    child: MasonryGridView.builder(
                      physics: defaultScrollPhysics,
                      clipBehavior: Clip.none,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.onMobile ? 2 : 4,
                      ),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: brand.products.length,
                      itemBuilder: (context, index) {
                        final product = brand.products[index];
                        return ProductCard(product: product, type: 'brand');
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
