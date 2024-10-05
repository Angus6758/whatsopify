
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/categories/controller/category_ctrl.dart';
import 'package:seller_management/features/product/view/categories/view/local/categories_product_loading.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/m_grid_view_with_footer.dart';
import 'package:seller_management/features/product/view/products/view/local/product_card.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../_widgets/_widgets.dart';

class CategoriesProductsView extends HookConsumerWidget {
  const CategoriesProductsView(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryData = ref.watch(categoryCtrlProvider(id));
    final categoryCtrl =
        useCallback(() => ref.read(categoryCtrlProvider(id).notifier));

    return categoryData.when(
      error: ErrorView1.withScaffold,
      loading: () => const CategoriesProductLoading(),
      data: (details) {
        final category = details.category;
        final products = details.products;
        return Scaffold(
          appBar: KAppBar(
            leading: SquareButton.backButton(
              onPressed: () => context.pop(),
            ),
            title: Text(category.name),
          ),
          body: Padding(
            padding: defaultPadding,
            child: products.isEmpty
                ? const Center(child: NoItemsAnimation())
                : RefreshIndicator(
                    onRefresh: () => categoryCtrl().reload(),
                    child: MGridViewWithFooter(
                      physics: defaultScrollPhysics,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: products.length,
                      crossAxisCount: context.onMobile ? 2 : 4,
                      pagination: products.pagination,
                      onPrevious: () => categoryCtrl().handlePagination(false),
                      onNext: () => categoryCtrl().handlePagination(true),
                      builder: (context, index) {
                        return ProductCard(
                          product: products[index],
                          type: 'category',
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}
