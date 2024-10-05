import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/features/add_product/view/local/local.dart';
import 'package:seller_management/main.export.dart';

class ProductBasicInformation extends HookConsumerWidget {
  const ProductBasicInformation({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));

    return ShadowContainer(
      padding: Insets.padAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.product_basic_info.tr(),
            style: context.textTheme.titleLarge,
          ),
          const Gap(Insets.med),
          const Divider(),
          const Gap(Insets.med),
          Text(
            LocaleKeys.product_title.tr(),
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).markAsRequired(),
          const Gap(Insets.sm),
          //!
          FormBuilderTextField(
            initialValue: productState.name,
            name: 'name',
            decoration: InputDecoration(
              hintText: LocaleKeys.enter_product_title.tr(),
            ),
            validator: FormBuilderValidators.required(),
          ),
          const Gap(Insets.med),
          SectorButton(
            title: LocaleKeys.add_basic_info.tr(),
            onEditSheetWidget: BasicProductInfoSheet(
              editingProduct: editingProduct,
            ),
            isComplete: productState.isBasicInfoDone(),
          ),
        ],
      ),
    );
  }
}
