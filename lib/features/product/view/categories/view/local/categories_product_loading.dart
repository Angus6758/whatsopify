
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../../_widgets/_widgets.dart';

class CategoriesProductLoading extends StatelessWidget {
  const CategoriesProductLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(TR.products(context)),
      ),
      body: Padding(
        padding: defaultPadding.copyWith(top: 10),
        child: MasonryGridView.builder(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: 10,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return KShimmer.card(height: 200);
          },
        ),
      ),
    );
  }
}
