import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

class ProductCategoriesSheet extends HookConsumerWidget {
  const ProductCategoriesSheet({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));

    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    final categories =
        ref.watch(localAuthConfigProvider.select((v) => v?.categories));

    final subCategories = categories
        ?.where((c) => c.id == productState.categoryId?.asInt)
        .firstOrNull
        ?.subCategory
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: context.height / 2,
        child: ShadowContainer(
          child: Padding(
            padding: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.product_categories.tr(),
                  style: context.textTheme.titleLarge,
                ),
                const Gap(Insets.med),
                const Divider(),
                const Gap(Insets.med),
                Text(
                  LocaleKeys.categories.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).markAsRequired(),
                const Gap(Insets.sm),
                //!
                if (categories != null && categories.isNotEmpty)
                  FormBuilderDropField<int>(
                    name: 'category_id',
                    itemCount: categories.length,
                    initialValue: productState.categoryId?.asInt,
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
                  )
                else
                  WarningBox(LocaleKeys.no_categories_found.tr()),

                const Gap(Insets.lg),

                Text(
                  LocaleKeys.sub_categories.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.sm),
                if (subCategories != null && subCategories.isNotEmpty)
                  FormBuilderDropField<int>(
                    name: 'sub_category_id',
                    itemCount: subCategories.length,
                    initialValue: productState.subCategoryId?.asInt,
                    hintText: LocaleKeys.select_item.tr(),
                    onChanged: (v) {
                      productCtrl().setSubCategory(v.toString());
                    },
                    itemBuilder: (context, index) {
                      final subCategory = subCategories[index];
                      return DropdownMenuItem(
                        value: subCategory.id,
                        child: Text(subCategory.name.toTitleCase),
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

                const Gap(Insets.offset),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          productCtrl().setSubCategory(null);
                          productCtrl().setCategory(null);
                          context.pop();
                        },
                        child: Text(LocaleKeys.clear.tr()),
                      ),
                    ),
                    const Gap(Insets.def),
                    Expanded(
                      child: SubmitButton.dense(
                        onPressed: (l) => context.pop(),
                        child: Text(LocaleKeys.submit.tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
