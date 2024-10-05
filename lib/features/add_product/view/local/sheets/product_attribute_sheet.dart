import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

class ProductAttributeSheet extends HookConsumerWidget {
  const ProductAttributeSheet({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  List<String> getCombinations(List<List<String>> lists) {
    if (lists.isEmpty) return [];
    List<String> result = lists.first;
    for (int i = 1; i < lists.length; i++) {
      result = combine(result, lists[i]);
    }
    return result;
  }

  List<String> combine(List<String> list1, List<String> list2) {
    List<String> result = [];
    for (String value1 in list1) {
      for (String value2 in list2) {
        result.add('$value1-$value2');
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));
    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    final attributes =
        ref.watch(localAuthConfigProvider.select((v) => v?.attributes ?? []));

    final attrMain = useState<List<AttributeData>>([]);
    final attrSub = useState<Map<String, List<String>>>({});

    final initiateMainAttributes = useCallback(
      () {
        final choices = productState.choiceNos ?? [];
        final initAttrMain =
            attributes.where((e) => choices.contains('${e.id}'));
        attrMain.value = initAttrMain.toList();
      },
      const [],
    );

    final initiateSubAttributes = useCallback(
      () {
        final options = productState.choiceOptions ?? {};
        final initAttrSub = <String, List<String>>{};
        for (var MapEntry(:key, :value) in options.entries) {
          final parseKey = key.replaceAll('choice_options_', '');
          final name = attributes
              .where((e) => '${e.id}' == parseKey)
              .map((e) => e.name)
              .first;

          initAttrSub[name] = value;
        }
        attrSub.value = initAttrSub;
      },
      const [],
    );

    useEffect(() {
      initiateMainAttributes();
      initiateSubAttributes();

      return null;
    }, const []);

    final combinedList = useState<List<String>>([]);

    final getCombinedAttribute = useCallback(
      () {
        List<List<String>> matrix = [];
        for (var value in attrSub.value.entries) {
          matrix.add(value.value);
        }
        final combinations = getCombinations(matrix);
        combinedList.value = combinations;
      },
      [attrMain.value, attrSub.value],
    );

    useEffect(() {
      getCombinedAttribute();
      return null;
    }, [attrMain.value, attrSub.value]);

    Map<String, String> initValue() {
      if (productState.attributeData == null) return {};
      final map = <String, String>{};

      for (var attr in productState.attributeData!.entries) {
        map[attr.key] = attr.value.toString();
      }

      return map;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: context.height * .9,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: formKey,
                  initialValue: initValue(),
                  child: ShadowContainer(
                    padding: Insets.padAll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.product_attribute.tr(),
                          style: context.textTheme.titleLarge,
                        ),
                        const Divider(height: 25),

                        //! select main attr
                        DropDownField<AttributeData>(
                          itemCount: attributes.length,
                          headerText: LocaleKeys.attribute.tr(),
                          hintText: LocaleKeys.select_item.tr(),
                          onChanged: (v) {
                            final attr = attrMain.value.toList();
                            if (!attr.contains(v) && v != null) {
                              attrMain.value = attr..add(v);
                              productCtrl().updateChoice('${v.id}');
                            }
                          },
                          itemBuilder: (context, index) {
                            final attr = attributes[index];
                            return DropdownMenuItem(
                              value: attr,
                              child: Text(attr.name.toTitleCase),
                            );
                          },
                          bottom: () {
                            if (attrMain.value.isEmpty) return null;
                            return SizedBox(
                              height: 50,
                              child: ListView.separated(
                                itemCount: attrMain.value.length,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (_, __) =>
                                    const Gap(Insets.sm),
                                itemBuilder: (context, index) {
                                  final att = attrMain.value[index];
                                  return Center(
                                    child: SimpleChip(
                                      label: att.name,
                                      onDeleteTap: () {
                                        final copy = attrMain.value.toList();
                                        copy.removeWhere(
                                          (e) => e.name == att.name,
                                        );
                                        attrMain.value = copy;
                                        final subCopy = {...attrSub.value};
                                        subCopy.remove(att.name);
                                        attrSub.value = subCopy;
                                        productCtrl().updateChoice('${att.id}');
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        if (attrMain.value.isNotEmpty)
                          const Divider(height: 30),

                        //! selected main attr
                        for (var mainAtt in attrMain.value)
                          Padding(
                            padding: const EdgeInsets.only(bottom: Insets.def),
                            child: DropDownField<AttributeData>(
                              itemCount: mainAtt.values.length,
                              headerText: mainAtt.name.titleCaseSingle,
                              hintText: 'Select ${mainAtt.name}',
                              onChanged: (v) {
                                if (v != null) {
                                  final values = [
                                    ...?attrSub.value[mainAtt.name]
                                  ];
                                  var name = v.name.replaceAll(' ', '');
                                  if (values.contains(name)) {
                                    values.remove(name);
                                  } else {
                                    values.add(name);
                                  }
                                  final copy = {...attrSub.value};
                                  copy[mainAtt.name] = values;
                                  attrSub.value = copy;
                                  productCtrl()
                                      .addChoiceOption('${mainAtt.id}', name);
                                }
                              },
                              itemBuilder: (context, index) {
                                final val = mainAtt.values[index];
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val.name.toTitleCase),
                                );
                              },
                              bottom: () {
                                final attSubValue = attrSub.value[mainAtt.name];
                                if (attSubValue.isNullOrEmpty()) return null;

                                return SizedBox(
                                  height: 50,
                                  child: ListView.separated(
                                    itemCount: attSubValue?.length ?? 0,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (_, __) =>
                                        const Gap(Insets.sm),
                                    itemBuilder: (context, index) {
                                      final attrValue = attSubValue![index];
                                      return Center(
                                        child: SimpleChip(
                                          label: attrValue,
                                          onDeleteTap: () {
                                            final name = mainAtt.name;
                                            final values =
                                                attrSub.value[name]?.toList();

                                            if (values == null) return;

                                            values.remove(attrValue);

                                            final copy = {...attrSub.value};

                                            copy[name] = values;

                                            if (copy[name]?.isEmpty == true) {
                                              copy.remove(name);
                                            }
                                            attrSub.value = copy;

                                            productCtrl().removeChoiceOption(
                                              '${mainAtt.id}',
                                              attrValue,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        if (attrSub.value.isNotEmpty) const Divider(height: 30),

                        for (var v in combinedList.value)
                          Column(
                            key: ValueKey(v),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(Insets.sm),
                              Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(LocaleKeys.quantity.tr(),
                                                style:
                                                    context.textTheme.bodyLarge)
                                            .markAsRequired(),
                                        const Gap(Insets.sm),
                                        FormBuilderTextField(
                                          name: 'qty_$v',
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: LocaleKeys.quantity.tr(),
                                          ),
                                          validator:
                                              FormBuilderValidators.required(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(Insets.def),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(LocaleKeys.price.tr(),
                                                style:
                                                    context.textTheme.bodyLarge)
                                            .markAsRequired(),
                                        const Gap(Insets.sm),
                                        FormBuilderTextField(
                                          name: 'price_$v',
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: LocaleKeys.price.tr(),
                                          ),
                                          validator:
                                              FormBuilderValidators.required(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(Insets.def),
                            ],
                          ),
                        const Gap(Insets.lg),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: Insets.padAll,
              child: SubmitButton(
                onPressed: (l) {
                  final state = formKey.currentState!;
                  if (!state.saveAndValidate()) return;

                  final data = {...state.value};

                  final keys = state.fields.keys.toList();

                  data.removeWhere((key, value) => !keys.contains(key));

                  productCtrl().setAttribute(data);

                  context.pop();
                },
                child: Text(LocaleKeys.submit.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
