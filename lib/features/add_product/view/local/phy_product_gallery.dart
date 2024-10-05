import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/features/add_product/view/local/choose_button.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

class ProductGallery extends HookConsumerWidget {
  const ProductGallery({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));

    final sizeGuide =
        ref.watch(localAuthConfigProvider.select((v) => v?.sizeGuide));

    return ShadowContainer(
      child: Padding(
        padding: Insets.padAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.product_gallery.tr(),
              style: context.textTheme.titleLarge,
            ),
            const Gap(Insets.med),
            const Divider(),
            const Gap(Insets.med),
            Text(
              LocaleKeys.thumbnail_image.tr(),
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).markAsRequired(),

            const Gap(Insets.def),

            //!
            ChooseButton(
              name: 'featured_image',
              onTap: (files) => productCtrl().updateThumbImage(files.first),
              imageDimension: sizeGuide?.feature,
            ),
            const Gap(Insets.med),
            if (productState.featuredImage.isNotNullOrEmpty())
              ProductImageCard(
                image: productState.featuredImage!,
              ),

            const Gap(Insets.lg),
            Text(
              LocaleKeys.gallery_image.tr(),
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).markAsRequired(),
            const Gap(Insets.sm),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChooseButton(
                  name: 'gallery_image',
                  multiPick: true,
                  onTap: (files) => productCtrl().addGalleryImage(files),
                  imageDimension: sizeGuide?.gallery,
                ),
              ],
            ),
            const Gap(Insets.med),
            if (productState.gallery.isNotNullOrEmpty())
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productState.gallery!.length,
                  itemBuilder: (context, index) {
                    final img = productState.gallery![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ProductImageCard(
                        image: img,
                        onDelete: img.fold(
                          (l) => () {
                            productCtrl().removeGalleryImage(l, true);
                          },
                          (r) => () {
                            productCtrl().removeGalleryImage(r.path);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProductImageCard extends StatelessWidget {
  const ProductImageCard({
    super.key,
    required this.image,
    this.onDelete,
  });

  final Function()? onDelete;
  final Either<String, File> image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: Corners.medBorder,
            color: context.colorTheme.onSurface.withOpacity(.05),
          ),
          child: Padding(
            padding: Insets.padAll,
            child: ClipRRect(
              borderRadius: Corners.medBorder,
              child: image.fold(
                (l) => HostedImage.square(l, dimension: 50),
                (r) => Image.file(r, height: 50, width: 50),
              ),
            ),
          ),
        ),
        if (onDelete != null)
          Positioned(
            right: 3,
            top: 3,
            child: GestureDetector(
              onTap: onDelete,
              child: CircleAvatar(
                backgroundColor: context.colorTheme.error.withOpacity(.2),
                radius: 12,
                child: Icon(
                  Icons.close,
                  color: context.colorTheme.error,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
