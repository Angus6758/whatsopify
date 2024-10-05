
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/content/brand_models.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../_widgets/_widgets.dart';

class BrandShowcase extends ConsumerWidget {
  const BrandShowcase({super.key, required this.brands});

  final List<BrandData> brands;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.none,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brands.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.onMobile ? 3 : 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final brand = brands[index];
        return InkWell(
          borderRadius: defaultRadius,
          onTap: () => RouteNames.brandProducts
              .pushNamed(context, pathParams: {'id': brand.uid}),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0, color: context.colors.secondaryContainer),
              borderRadius: defaultRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: context.onMobile ? 50 : 70,
                    width: context.onMobile ? 50 : 70,
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: HostedImage.provider(brand.logo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    brand.name,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
