import 'package:flutter/material.dart';
import 'package:seller_management/features/product/controller/product_ctrl.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';
import 'package:share_plus/share_plus.dart';

import 'digital_edit_attribute_sheet.dart';

class DigitalProductCard extends HookConsumerWidget {
  const DigitalProductCard({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCtrl = useCallback(
      () => ref.read(productDetailsCtrlProvider(product.uid).notifier),
    );
    return Stack(
      children: [
        GestureDetector(
          onTap: () => RouteNames.productDetails
              .pushNamed(context, pathParams: {'id': product.uid}),
          child: ShadowContainer(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Corners.medRadius,
                  ),
                  child: Center(
                    child: HostedImage(
                      height: 130,
                      width: double.infinity,
                      product.featuredImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: Insets.padH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(Insets.med),
                      Text(
                        product.name,
                        style: context.textTheme.bodyLarge,
                        maxLines: 1,
                      ),
                      if (product.digitalAttributes.isNotEmpty)
                        Text(
                          product.digitalAttributes.first.price.formate(),
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorTheme.primary,
                          ),
                        ),
                      if (product.digitalAttributes.isEmpty)
                        Text(
                          product.price.formate(),
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (product.isPhysical)
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  showDragHandle: true,
                                  context: Get.context!,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: context.mq.viewInsets.bottom,
                                      ),
                                      child: DigitalAttributeBottomSheet(
                                        product: product,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Edit Stock',
                                style: TextStyle(
                                  color: context.colorTheme.primary,
                                ),
                              ),
                            ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                builder: (context) => DeleteAlert(
                                  title: 'Really want to delete this product?',
                                  onDelete: () async {
                                    await productCtrl().delete();
                                    if (context.mounted) context.nPop();
                                  },
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  context.colorTheme.onSurface.withOpacity(.05),
                              radius: 15,
                              child: Icon(
                                Icons.delete,
                                size: 18,
                                color: context.colorTheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(Insets.med),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => RouteNames.addDigitalProduct
                    .pushNamed(context, extra: product),
                child: CircleAvatar(
                  backgroundColor: context.colorTheme.primary,
                  radius: 15,
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: context.colorTheme.onPrimary,
                  ),
                ),
              ),
              const Gap(Insets.sm),
              if (product.url.isNotEmpty)
                GestureDetector(
                  onTap: () => Share.shareUri(Uri.parse(product.url)),
                  child: CircleAvatar(
                    backgroundColor: context.colorTheme.primary,
                    radius: 15,
                    child: Icon(
                      Icons.share,
                      size: 18,
                      color: context.colorTheme.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorTheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Corners.medRadius,
                bottomRight: Corners.medRadius,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Text(
                product.status,
                style: TextStyle(
                  color: context.colorTheme.onPrimary,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
