import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/main.export.dart';

class ProductWarrantyPolicySheet extends HookConsumerWidget {
  const ProductWarrantyPolicySheet({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PhysicalStoreState(:warrantyPolicy) =
        ref.watch(physicalStoreCtrlProvider(editingProduct));

    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    final fieldKey = useMemoized(GlobalKey<FormBuilderTextState>.new);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: context.height * .8,
        child: SingleChildScrollView(
          child: ShadowContainer(
            padding: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.product_warranty_policy.tr(),
                  style: context.textTheme.titleLarge,
                ),
                const Gap(Insets.med),
                const Divider(),
                const Gap(Insets.med),
                Text(
                  LocaleKeys.add_warranty_policy.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.sm),
                HtmlEditorView(
                  fieldKey: fieldKey,
                  name: 'warranty_policy',
                  initialValue: warrantyPolicy,
                  hint: LocaleKeys.enter_warranty_policy.tr(),
                ),
                const Gap(Insets.offset),
                SubmitButton(
                  onPressed: (l) {
                    final value = fieldKey.currentState?.value;

                    productCtrl().copyWith(
                      (c) => c.copyWith(warrantyPolicy: () => value),
                    );

                    context.pop();
                  },
                  child: Text(
                    LocaleKeys.submit.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
