import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_digital_ctrl.dart';
import 'package:seller_management/main.export.dart';

class BasicInformation extends HookConsumerWidget {
  const BasicInformation({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(digitalStoreCtrlProvider(editingProduct));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.product_basic_info.tr(),
          style: context.textTheme.titleLarge,
        ),
        const Gap(Insets.med),
        ShadowContainer(
          child: Padding(
            padding: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.product_title.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).markAsRequired(),
                const Gap(Insets.sm),

                //!!
                FormBuilderTextField(
                  name: 'name',
                  initialValue: productState.name,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enter_product_title.tr(),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const Gap(Insets.lg),
                Text(
                  LocaleKeys.product_description.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).markAsRequired(),
                const Gap(Insets.sm),

                //!
                HtmlEditorView(
                  name: 'description',
                  hint: LocaleKeys.enter_product_description.tr(),
                  initialValue: productState.description,
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
