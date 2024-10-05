import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_config.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../_core/lang/locale_keys.g.dart';

class ProductQuickActionCard extends StatelessWidget {
  const ProductQuickActionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Padding(
        padding: Insets.padAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.Product.tr(),
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const Gap(Insets.med),
            ShadowContainer(
              width: double.infinity,
              child: Padding(
                padding: Insets.padAll,
                child: Column(
                  children: [
                    const Gap(Insets.med),
                    SvgPicture.asset(
                      AssetsConst.addProduct,
                      height: context.onTab ? 150 : 90,
                    ),
                    const Gap(Insets.med),
                    Text(
                      LocaleKeys.add_product_title.tr(),
                      style:
                          context.onTab ? context.textTheme.titleLarge : null,
                      textAlign: TextAlign.center,
                    ),
                    if (context.onTab) const Gap(Insets.lg),
                    SizedBox(
                      height: context.onTab ? 60 : 40,
                      width: context.onTab ? context.width / 4 : null,
                      child: FilledButton(
                        onPressed: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: Get.context!,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return const ProductAddSheet();
                            },
                          );
                        },
                        child: Text(
                          LocaleKeys.add_product.tr(),
                        ),
                      ),
                    ),
                    const Gap(Insets.med),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductAddSheet extends HookConsumerWidget {
  const ProductAddSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAddProduct = ref.watch(
      localAuthConfigProvider
          .select((v) => (v?.subscription?.totalProduct ?? 0) > 0),
    );
    return SizedBox(
      height: context.onTab ? context.height / 2.5 : context.height / 3,
      child: Column(
        children: [
          if (canAddProduct)
            SvgPicture.asset(
              AssetsConst.productAdd,
              height: 80,
              colorFilter: ColorFilter.mode(
                context.colorTheme.primary,
                BlendMode.srcIn,
              ),
            )
          else
            Lottie.asset(AssetsConst.warning, height: 80),
          const Gap(Insets.lg),
          if (canAddProduct)
            Text(
              LocaleKeys.add_product_title.tr(),
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            )
          else
            Text(
              LocaleKeys.dont_have_any_subscription.tr(),
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          const Gap(Insets.lg),
          if (!canAddProduct)
            SubmitButton(
              height: 40,
              padding: Insets.padAll,
              onPressed: (l) async {
                context.nPop();
                RouteNames.planUpdate.goNamed(context);
              },
              child: Text(
                LocaleKeys.subscribe_now.tr(),
              ),
            )
          else
            Padding(
              padding: Insets.padH,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.nPop();
                        RouteNames.addProduct.pushNamed(context);
                      },
                      child: ShadowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 5,
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                AssetsConst.totalProduct,
                                height: 40,
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.add_physical_product.tr(),
                                style: context.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(Insets.med),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.nPop();
                        RouteNames.addDigitalProduct.pushNamed(context);
                      },
                      child: ShadowContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 5,
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                AssetsConst.digitalProduct,
                                height: 40,
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.add_digital_product.tr(),
                                style: context.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
