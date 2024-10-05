import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/local/product_grid_view.dart';
import 'package:seller_management/main.export.dart';

import 'local/product_card.dart';

class InHouseProductList extends ConsumerWidget {
  const InHouseProductList({super.key});

  final status = const ['all', 'trashed', 'refuse'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          ButtonsTabBar(
            backgroundColor: context.isDark
                ? context.colorTheme.surfaceTint
                : context.colorTheme.primary,
            unselectedBackgroundColor:
                context.colorTheme.onSurface.withOpacity(.05),
            unselectedLabelStyle:
                TextStyle(color: context.colorTheme.onSurface),
            labelStyle: TextStyle(
              color: context.colorTheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              ...status.map(
                (e) => Tab(text: "${e.titleCaseSingle} Product"),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ...status.map(
                  (e) {
                    final parsed = e == 'all' ? null : e;
                    return ProductGridView(
                      status: parsed,
                      isDigital: false,
                      childBuilder: (product) => ProductCard(
                        product: product,
                        permanentDelete: e == 'trashed',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
