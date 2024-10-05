import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/main.export.dart';

import 'local.dart';
import 'sheets/tax_config_sheet.dart';

class ProductInfoList extends HookConsumerWidget {
  const ProductInfoList({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));

    return Column(
      children: [
        SectorButton(
          title: LocaleKeys.product_attribute.tr(),
          isComplete: productState.isAttributeValid(),
          onEditSheetWidget: ProductAttributeSheet(
            editingProduct: editingProduct,
          ),
        ),
        const Gap(Insets.lg),
        SectorButton(
          title: LocaleKeys.product_categories.tr(),
          isComplete: productState.isCategoryDone(),
          onEditSheetWidget: ProductCategoriesSheet(
            editingProduct: editingProduct,
          ),
        ),
        const Gap(Insets.lg),
        SectorButton(
          title: LocaleKeys.product_brand.tr(),
          isComplete: productState.brandId != null,
          onEditSheetWidget: ProductBrandSheet(
            editingProduct: editingProduct,
          ),
        ),
        const Gap(Insets.lg),
        SectorButton(
          isComplete: productState.shippingDeliveryIds.isNotNullOrEmpty(),
          title: LocaleKeys.product_shipping.tr(),
          onEditSheetWidget: ProductShippingSheet(
            editingProduct: editingProduct,
          ),
        ),
        const Gap(Insets.lg),
        SectorButton(
          isComplete: productState.isTaxDataDone(),
          title: 'Tax Configuration',
          onEditSheetWidget: TaxConfigSheet(
            editingProduct: editingProduct,
          ),
        ),
        const Gap(Insets.lg),
        SectorButton(
          title: LocaleKeys.product_warranty_policy.tr(),
          isComplete: productState.warrantyPolicy.isNotNullOrEmpty(),
          onEditSheetWidget: ProductWarrantyPolicySheet(
            editingProduct: editingProduct,
          ),
        ),
        const Gap(Insets.lg),
        SectorButton(
          title: LocaleKeys.meta_data.tr(),
          isComplete: productState.isMetaDataDone(),
          onEditSheetWidget: ProductMetaSheet(
            editingProduct: editingProduct,
          ),
        ),
      ],
    );
  }
}
