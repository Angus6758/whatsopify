import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/features/add_product/controller/add_digital_ctrl.dart';
import 'package:seller_management/main.export.dart';

class DigitalAttributeBottomSheet extends HookConsumerWidget {
  const DigitalAttributeBottomSheet({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final productState = ref.watch(digitalStoreCtrlProvider(product));

    final productCtrl = useCallback(
      () => ref.read(digitalStoreCtrlProvider(product).notifier),
    );

    return SizedBox(
      height: context.height * .8,
      child: Padding(
        padding: Insets.padAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Stock',
              style: context.textTheme.titleLarge,
            ),
            const Gap(Insets.def),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var stock in [...?productState.attributes])
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: .5,
                              color: context.colorTheme.primary,
                            ),
                            borderRadius: Corners.medBorder,
                          ),
                          padding: Insets.padAll,
                          margin: const EdgeInsets.only(bottom: Insets.def),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  HostedImage.square(
                                    product.featuredImage,
                                    dimension: 70,
                                  ),
                                  const Gap(Insets.def),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: context.textTheme.bodyLarge,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: 'Attributes: ',
                                          children: [
                                            TextSpan(
                                              text: stock.name,
                                              style: context
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                color:
                                                    context.colorTheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(Insets.med),
                              Row(
                                children: [
                                  Flexible(
                                    child: FormBuilderTextField(
                                      name: 'attr_name_${stock.id}',
                                      initialValue: stock.name,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter attribute name',
                                      ),
                                      validator:
                                          FormBuilderValidators.required(),
                                    ),
                                  ),
                                  const Gap(Insets.def),
                                  Flexible(
                                    child: FormBuilderTextField(
                                      name: 'attr_price_${stock.id}',
                                      initialValue: stock.price,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Price',
                                      ),
                                      validator:
                                          FormBuilderValidators.required(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SubmitButton(
              onPressed: (l) async {
                final state = formKey.currentState!;
                if (!state.saveAndValidate()) return;

                l.value = true;
                productCtrl().addInfoFromMap(state.value);
                await productCtrl().updateProductData(product.uid);
                l.value = false;

                if (context.mounted) context.nPop();
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
