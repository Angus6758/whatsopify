import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_digital_ctrl.dart';
import 'package:seller_management/features/add_product/view/local/sheets/tax_config_sheet.dart';
import 'package:seller_management/main.export.dart';

import 'local/local.dart';

class AddDigitalProductView extends HookConsumerWidget {
  const AddDigitalProductView(
    this.editingProduct, {
    super.key,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final productState = ref.watch(digitalStoreCtrlProvider(editingProduct));
    final productCtrl = useCallback(
        () => ref.read(digitalStoreCtrlProvider(editingProduct).notifier));

    return Scaffold(
      appBar: AppBar(
        title: editingProduct != null
            ? Text(LocaleKeys.update_digital_product.tr())
            : Text(LocaleKeys.add_digital_product.tr()),
      ),
      body: SingleChildScrollView(
        padding: Insets.padAll,
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BasicInformation(editingProduct: editingProduct),
              const Gap(Insets.lg),
              DigitalProductGallery(editingProduct: editingProduct),
              const Gap(Insets.med),
              CategoriesSelectionView(editingProduct: editingProduct),
              const Gap(Insets.med),
              ProductStock(editingProduct: editingProduct),
              const Gap(Insets.med),
              TaxInfoCard(
                amounts: productState.taxAmounts,
                types: productState.taxTypes,
              ),
              const Gap(Insets.med),
              MetaDataCard(editingProduct: editingProduct),
              const Gap(Insets.lg),
              SubmitButton(
                onPressed: (isLoading) async {
                  final state = formKey.currentState!;
                  if (!state.saveAndValidate()) return;

                  final value = {...state.value};
                  final keys = state.fields.keys.toList();
                  value.removeWhere((key, value) => !keys.contains(key));

                  productCtrl().addInfoFromMap(value);

                  final productState =
                      ref.watch(digitalStoreCtrlProvider(editingProduct));

                  if (productState.categoryId.isNullOrEmpty()) {
                    Toaster.showError('Category is required');
                    return;
                  }
                  if (productState.featuredImage.isNullOrEmpty()) {
                    state.fields['featured_image']
                        ?.invalidate('Featured image is required');
                    return;
                  }
                  if (productState.attributeNames.isNullOrEmpty()) {
                    Toaster.showError('Attributes is required');
                    return;
                  }

                  isLoading.value = true;
                  editingProduct != null
                      ? await productCtrl()
                          .updateProductData(editingProduct!.uid)
                      : await productCtrl().storeProductData();

                  isLoading.value = false;

                  if (context.mounted) context.pop();
                },
                child: editingProduct != null
                    ? Text(LocaleKeys.update_product.tr())
                    : Text(LocaleKeys.add_product.tr()),
              ),
              const Gap(Insets.lg),
            ],
          ),
        ),
      ),
    );
  }
}
