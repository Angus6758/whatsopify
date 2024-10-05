
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/content/category_models.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../../_widgets/_widgets.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.category});
  final CategoriesData category;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: defaultRadius,
      onTap: () => RouteNames.categoryProducts1
          .pushNamed(context, pathParams: {'id': category.uid}),
      child: Container(
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
        height: 110,
        width: 120,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: context.colors.onErrorContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: defaultPaddingAll,
                child: ClipRRect(
                  borderRadius: defaultRadius,
                  child: HostedImage(category.image, height: 40),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  category.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
