import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_digital_ctrl.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

class CategoriesSelectionView extends HookConsumerWidget {
  const CategoriesSelectionView({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(localAuthConfigProvider.select((v) => v?.categories));

    final productState = ref.watch(digitalStoreCtrlProvider(editingProduct));
    final productCtrl = useCallback(
        () => ref.read(digitalStoreCtrlProvider(editingProduct).notifier));

    final subCategories = categories
        ?.firstWhereOrNull((c) => c.id == productState.categoryId?.asInt)
        ?.subCategory
        .toList();

    return ShadowContainer(
      padding: Insets.padAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.product_categories.tr(),
            style: context.textTheme.titleLarge,
          ),
          const Gap(Insets.med),
          if (categories != null && categories.isNotEmpty)
            DropDownField<int>(
              headerText: LocaleKeys.categories.tr(),
              itemCount: categories.length,
              value: productState.categoryId?.asInt,
              hintText: LocaleKeys.select_item.tr(),
              onChanged: (v) {
                productCtrl().setSubCategory(null);
                productCtrl().setCategory(v.toString());
              },
              itemBuilder: (context, index) {
                final category = categories[index];
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name.toTitleCase),
                );
              },
              isRequired: true,
            )
          else
            WarningBox(
              LocaleKeys.no_categories_found.tr(),
            ),
          const Gap(Insets.lg),
          Text(
            LocaleKeys.sub_categories.tr(),
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(Insets.sm),
          if (subCategories.isNotNullOrEmpty())
            DropDownField<int>(
              itemCount: subCategories?.length,
              value: productState.subCategoryId?.asInt,
              hintText: LocaleKeys.select_item.tr(),
              onChanged: (v) {
                productCtrl().setSubCategory(v.toString());
              },
              itemBuilder: (context, index) {
                final subCategory = subCategories?[index];
                return DropdownMenuItem(
                  value: subCategory?.id ?? -1,
                  child: Text(subCategory?.name.toTitleCase ?? ''),
                );
              },
            )
          else
            WarningBox(
              subCategories == null
                  ? LocaleKeys.add_a_categories_first.tr()
                  : LocaleKeys.no_sub_categories_found.tr(),
              type: WarningBoxType.info,
            ),
        ],
      ),
    );
  }
}
