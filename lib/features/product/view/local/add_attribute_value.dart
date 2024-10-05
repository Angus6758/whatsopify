import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/main.export.dart';

import '../../controller/product_ctrl.dart';
import 'value_attribute_table.dart';

class AddAttributeValueView extends HookConsumerWidget {
  const AddAttributeValueView({
    required this.attribute,
    required this.products,
    super.key,
  });

  final DigitalAttribute attribute;
  final ProductModel products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldKey = useMemoized(() => GlobalKey<FormBuilderTextState>());
    final productCtrl = useCallback(
        () => ref.read(productDetailsCtrlProvider(products.uid).notifier));

    final valueList = useState<List<DigitalAttributeValue>>([]);

    useEffect(() {
      valueList.value = attribute.values;
      return null;
    }, const []);

    Future<void> deleteValue(String id) async {
      await productCtrl().attributeValueDelete(id);

      valueList.value = valueList.value.where((e) => e.uid != id).toList();
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: context.height,
        child: Padding(
          padding: Insets.padAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
              Text(
                'Add Value',
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(Insets.lg),
              ShadowContainer(
                child: Padding(
                  padding: Insets.padAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Text',
                        style: context.textTheme.bodyLarge,
                      ).markAsRequired(),
                      const Gap(Insets.sm),
                      FormBuilderTextField(
                        key: fieldKey,
                        name: 'text',
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Text format e.g key1,key2,key3',
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const Gap(Insets.lg),
                      SubmitButton(
                        onPressed: (l) async {
                          final state = fieldKey.currentState!;
                          if (!state.validate()) return;

                          final formData = state.value ?? '';
                          l.value = true;

                          final result = await productCtrl()
                              .storeAttributeValue(attribute.uid, formData);

                          valueList.value = result;
                          l.value = false;
                          state.reset();

                          Toaster.showSuccess('Attribute add successful');
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(Insets.lg),
              if (valueList.value.isNotEmpty) ...[
                Text(
                  'Attribute Values',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.lg),
                ShadowContainer(
                  child: Padding(
                    padding: Insets.padAll,
                    child: Column(
                      children: [
                        const ValueAttributeTable(
                          value: 'Value',
                          status: 'Status',
                          action: Text('Action'),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: valueList.value.length,
                          itemBuilder: (context, index) {
                            final values = valueList.value[index];
                            return Column(
                              children: [
                                const Divider(),
                                ValueAttributeTable(
                                  value: values.value,
                                  status: values.status,
                                  action: GestureDetector(
                                    onTap: () async {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            DeleteAlert(
                                          title:
                                              'Really want to delete this Attribute?',
                                          onDelete: () async {
                                            Logger(values.uid);
                                            await deleteValue(values.uid);
                                            if (context.mounted) context.nPop();
                                          },
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: context.colorTheme.error
                                          .withOpacity(.1),
                                      child: Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: context.colorTheme.error,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Gap(Insets.lg),
            ],
          ),
        ),
      ),
    );
  }
}
