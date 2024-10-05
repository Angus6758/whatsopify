import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_digital_ctrl.dart';
import 'package:seller_management/main.export.dart';

class ProductStock extends HookConsumerWidget {
  const ProductStock({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(digitalStoreCtrlProvider(editingProduct));
    final productCtrl = useCallback(
        () => ref.read(digitalStoreCtrlProvider(editingProduct).notifier));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          LocaleKeys.product_stock.tr(),
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).markAsRequired(),
        const SizedBox(height: 10),
        ShadowContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (editingProduct == null)
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        productCtrl().addNewAttributeField();
                      },
                      child: Text(
                        LocaleKeys.add_new_attribute.tr(),
                      ),
                    ),
                  ),
                const Gap(20),
                for (var attr in [...?productState.attributes])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Flexible(
                          child: FormBuilderTextField(
                            readOnly: editingProduct != null,
                            initialValue: attr.name.trim(),
                            name: 'attr_name_${attr.id}',
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.attribute_name.tr(),
                            ),
                            validator: FormBuilderValidators.required(),
                          ),
                        ),
                        const Gap(Insets.def),
                        Flexible(
                          child: FormBuilderTextField(
                            readOnly: editingProduct != null,
                            initialValue: attr.price,
                            name: 'attr_price_${attr.id}',
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.attribute_price.tr(),
                            ),
                            validator: FormBuilderValidators.required(),
                          ),
                        ),
                        if (editingProduct == null)
                          IconButton(
                            onPressed: () async {
                              await productCtrl().removeAttributeField(attr.id);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
