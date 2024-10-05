
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/brands/provider/brand_provider.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../_widgets/_widgets.dart';

class BrandsView extends ConsumerWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(brandListProvider);

    return Scaffold(
      appBar: KAppBar(
        title:Text(TR.brands(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: context.onMobile
            ? defaultPadding
            : const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.onMobile ? 3 : 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          physics: defaultScrollPhysics,
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];

            return InkWell(
              borderRadius: defaultRadius,
              onTap: () => RouteNames.brandProducts
                  .goNamed(context, pathParams: {'id': brand.uid}),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: context.colors.secondaryContainer,
                    ),
                    borderRadius: defaultRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HostedImage(
                          brand.logo,
                          height: context.onMobile ? 50 : 70,
                          width: context.onMobile ? 50 : 70,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          brand.name,
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
