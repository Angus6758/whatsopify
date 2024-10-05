import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../../../../_core/lang/locale_keys.g.dart';

class BasicProductInfoSheet extends HookConsumerWidget {
  const BasicProductInfoSheet({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));
    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    return SizedBox(
      height: context.height / 1.15,
      child: SingleChildScrollView(
        padding: Insets.padAll,
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(Insets.lg),
              ShadowContainer(
                child: Padding(
                  padding: Insets.padAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.regular_price.tr(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).markAsRequired(),
                      const Gap(Insets.sm),
                      //!
                      FormBuilderTextField(
                        name: 'price',
                        initialValue: productState.price,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: LocaleKeys.product_price.tr(),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const Gap(Insets.lg),

                      Text(
                        LocaleKeys.discount_percentage.tr(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(Insets.sm),
                      //!
                      FormBuilderTextField(
                        name: 'discount_percentage',
                        initialValue: productState.discountPercentage,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(hintText: '0'),
                        validator: (v) {
                          final val = int.tryParse(v ?? '0') ?? 0;
                          if (val.isNegative) return 'Enter Valid Number';
                          return null;
                        },
                      ),
                      const Gap(Insets.lg),

                      Text(
                        LocaleKeys.purchase_quantity_min.tr(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).markAsRequired(),
                      const Gap(Insets.sm),
                      //!
                      FormBuilderTextField(
                        name: 'minimum_purchase_qty',
                        initialValue: productState.minQty,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: LocaleKeys.min_qty_should_be.tr(),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            (v) {
                              final val = int.tryParse(v ?? '0') ?? 0;
                              if (val < 1) {
                                return LocaleKeys.min_qty_should_be.tr();
                              }
                              return null;
                            },
                          ],
                        ),
                      ),
                      const Gap(Insets.lg),
                      Text(
                        LocaleKeys.purchase_quantity_max.tr(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).markAsRequired(),
                      const Gap(Insets.sm),
                      FormBuilderTextField(
                        name: 'maximum_purchase_qty',
                        initialValue: productState.maxQty,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: LocaleKeys.max_qty_unlimited.tr(),
                        ),
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            (v) {
                              final val = int.tryParse(v ?? '0') ?? 0;
                              if (val < 1) {
                                return 'Max Qty should be more than 1';
                              }
                              return null;
                            },
                          ],
                        ),
                      ),
                      //!
                      const Gap(Insets.lg),
                      Text(
                        'Weight',
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(Insets.sm),
                      FormBuilderTextField(
                        name: 'weight',
                        initialValue: productState.weight,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Weight in kg',
                        ),
                      ),
                      //!
                      const Gap(Insets.lg),
                      Text(
                        'Shipping Fee',
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(Insets.sm),
                      FormBuilderTextField(
                        name: 'shipping_fee',
                        initialValue: productState.shippingFee,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Flat Shipping Fee',
                        ),
                      ),
                      //!
                      const Gap(Insets.lg),
                      Text(
                        'Multiply Shipping Fee',
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(Insets.sm),
                      DropDownField<bool>(
                        hintText: 'Shipping Fee Multiplier',
                        itemCount: 2,
                        value: productState.feeMultiplier,
                        onChanged: (v) =>
                            productCtrl().setShippingFeeMultiplier(v),
                        itemBuilder: (itemContext, index) {
                          final list = [true, false];
                          final it = list[index];
                          return DropdownMenuItem(
                            value: it,
                            child: Text(
                              it
                                  ? 'Multiply Shipping Fee by quantity'
                                  : 'Do not multiply',
                            ),
                          );
                        },
                      ),
                      //!
                      const Gap(Insets.lg),
                      Text(
                        LocaleKeys.short_description.tr(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).markAsRequired(),
                      const Gap(Insets.sm),
                      SizedBox(
                        height: 420,
                        child: HtmlEditorView(
                          name: 'short_description',
                          initialValue: productState.shortDescription,
                          validators: [FormBuilderValidators.required()],
                        ),
                      ),

                      const Gap(Insets.lg),
                      Text(
                        LocaleKeys.product_description.tr(),
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ).markAsRequired(),
                      const Gap(Insets.sm),
                      SizedBox(
                        height: 420,
                        child: HtmlEditorView(
                          name: 'description',
                          initialValue: productState.description,
                          validators: [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.viewPaddingOf(context).bottom),
                    ],
                  ),
                ),
              ),
              const Gap(Insets.lg),
              Padding(
                padding: Insets.padH,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: SubmitButton(
                    onPressed: (isLoading) {
                      var state = formKey.currentState;
                      final isOK = state!.saveAndValidate();
                      if (!isOK) return;

                      final data = state.value;
                      productCtrl().addInfoFromMap(data);

                      context.pop();
                    },
                    child: Text(LocaleKeys.submit.tr()),
                  ),
                ),
              ),
              const Gap(Insets.med),
            ],
          ),
        ),
      ),
    );
  }
}
