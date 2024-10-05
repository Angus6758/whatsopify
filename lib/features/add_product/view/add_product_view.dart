import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../../../_core/lang/locale_keys.g.dart';
import 'local/local.dart';

class AddProductView extends HookConsumerWidget {
  const AddProductView({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    return Scaffold(
      appBar: AppBar(
        title: editingProduct != null
            ? Text(LocaleKeys.update_product.tr())
            : Text(LocaleKeys.add_product.tr()),
      ),
      body: GestureDetector(
        onTap: () => hideSoftKeyboard(),
        child: SingleChildScrollView(
          padding: Insets.padH,
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(Insets.med),
                ProductBasicInformation(editingProduct: editingProduct),
                const Gap(Insets.lg),
                ProductGallery(editingProduct: editingProduct),
                const Gap(Insets.lg),
                ProductInfoList(editingProduct: editingProduct),
                const Gap(Insets.lg),
                SubmitButton(
                  onPressed: (l) async {
                    final state = formKey.currentState!;
                    if (!state.saveAndValidate()) return;

                    productCtrl().addInfoFromMap(state.value);
                    final productState =
                        ref.watch(physicalStoreCtrlProvider(editingProduct));

                    if (productState.featuredImage.isNullOrEmpty()) {
                      state.fields['featured_image']
                          ?.invalidate('Featured image is required');
                      return;
                    }
                    if (productState.gallery.isNullOrEmpty()) {
                      state.fields['gallery_image']
                          ?.invalidate('At least one image is required');
                      return;
                    }
                    var validate = productState.validateRequired();
                    if (!validate.$1) {
                      Toaster.showError(validate.$2);
                      return;
                    }

                    l.value = true;
                    editingProduct != null
                        ? await productCtrl()
                            .updateProductData(editingProduct!.uid)
                        : await productCtrl().storeProductData();
                    l.value = false;

                    if (context.mounted && editingProduct == null)
                      context.pop();
                  },
                  child: editingProduct != null
                      ? Text(LocaleKeys.upload_product.tr())
                      : Text(LocaleKeys.add_product.tr()),
                ),
                const Gap(Insets.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
