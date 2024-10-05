import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/features/product/controller/product_ctrl.dart';
import 'package:seller_management/main.export.dart';

class AddDigitalProductAttribute extends HookConsumerWidget {
  const AddDigitalProductAttribute({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCtrl = useCallback(
        () => ref.read(productDetailsCtrlProvider(product.uid).notifier));

    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    return Padding(
      padding: EdgeInsets.only(
        bottom: context.mq.viewInsets.bottom,
      ),
      child: SizedBox(
        height: context.height / 2,
        child: Padding(
          padding: Insets.padAll,
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Attribute Name').markAsRequired(),
                const Gap(Insets.sm),
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    hintText: 'Enter attribute name',
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const Gap(Insets.med),
                const Text('Price').markAsRequired(),
                const Gap(Insets.sm),
                FormBuilderTextField(
                  name: 'price',
                  decoration: const InputDecoration(
                    hintText: 'Enter attribute price',
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const Gap(Insets.med),
                Text(
                  'Sort Description',
                  style: context.textTheme.bodyLarge,
                ),
                const Gap(Insets.sm),
                SizedBox(
                  height: 100,
                  child: FormBuilderTextField(
                    name: 'short_details',
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Enter Sort Description',
                    ),
                  ),
                ),
                const Spacer(),
                SubmitButton(
                  onPressed: (isLoading) async {
                    final state = formKey.currentState!;
                    if (!state.saveAndValidate()) return;

                    isLoading.value = true;
                    await productCtrl().attributeStore(state.value);
                    isLoading.value = false;

                    if (context.mounted) context.nPop();
                  },
                  child: const Text('Add Attribute'),
                ),
                const Gap(Insets.med),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
