import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

class TaxConfigSheet extends HookConsumerWidget {
  const TaxConfigSheet({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));
    final productState = ref.watch(physicalStoreCtrlProvider(editingProduct));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: context.height * 0.8,
        child: ShadowContainer(
          child: SingleChildScrollView(
            padding: Insets.padAll,
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  TaxInfoCard(
                    amounts: productState.taxAmounts,
                    types: productState.taxTypes,
                  ),
                  SubmitButton(
                    onPressed: (l) {
                      final state = formKey.currentState!;
                      if (!state.saveAndValidate()) return;
                      final res = productCtrl().updateTaxData(state.value);
                      if (res) context.nPop();
                    },
                    child: Text(LocaleKeys.submit.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaxInfoCard extends HookConsumerWidget {
  const TaxInfoCard({
    super.key,
    required this.amounts,
    required this.types,
  });

  final List<String>? amounts;
  final List<String>? types;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taxConfigList =
        ref.watch(localAuthConfigProvider.select((v) => v?.taxConfigs ?? []));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tax Configuration',
          style: context.textTheme.titleLarge,
        ),
        const Gap(Insets.med),
        const Divider(),
        const Gap(Insets.med),
        for (var i = 0; i < taxConfigList.length; i++) ...[
          Text(
            taxConfigList[i].name,
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(Insets.sm),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: '${taxConfigList[i].id}^amount',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  initialValue: amounts?.elementAtOrNull(i),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
              ),
              const Gap(Insets.med),
              Expanded(
                child: FormBuilderDropField<bool>(
                  name: '${taxConfigList[i].id}^type',
                  initialValue: switch (types?.elementAtOrNull(i)) {
                    '0' => false,
                    '1' => true,
                    _ => null,
                  },
                  hintText: 'Type',
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final list = [true, false];
                    final isFlat = list[index];
                    return DropdownMenuItem(
                      value: isFlat,
                      child: Text(isFlat ? 'Flat' : 'Percentage'),
                    );
                  },
                ),
              ),
            ],
          ),
          const Gap(Insets.def),
        ],
      ],
    );
  }
}
