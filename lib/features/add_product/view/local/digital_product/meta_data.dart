import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_digital_ctrl.dart';
import 'package:seller_management/main.export.dart';

class MetaDataCard extends HookConsumerWidget {
  const MetaDataCard({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(digitalStoreCtrlProvider(editingProduct));
    final productCtrl = useCallback(
        () => ref.read(digitalStoreCtrlProvider(editingProduct).notifier));
    final keywordCtrl = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(Insets.lg),
        Text(
          LocaleKeys.meta_data.tr(),
          style: context.textTheme.titleLarge,
        ),
        const Gap(Insets.med),
        ShadowContainer(
          child: Padding(
            padding: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.meta_title.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.med),
                FormBuilderTextField(
                  name: 'meta_title',
                  initialValue: productState.metaTitle,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enter_meta_title.tr(),
                  ),
                ),
                const Gap(Insets.lg),
                Text(
                  LocaleKeys.meta_keyword.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.med),
                FormBuilderTextField(
                  name: 'meta_keywords',
                  controller: keywordCtrl,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.type_keywords.tr(),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        final txt = keywordCtrl.text;
                        if (txt.isEmpty) return;
                        productCtrl().updateMetaKeyword(txt);
                        keywordCtrl.clear();
                      },
                      child: Icon(
                        Icons.add,
                        color: context.colorTheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                if (productState.metaKeywords != null)
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      itemCount: productState.metaKeywords!.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const Gap(Insets.sm),
                      itemBuilder: (context, index) {
                        final keyword = productState.metaKeywords![index];
                        return Center(
                          child: SimpleChip(
                            label: keyword,
                            onDeleteTap: () {
                              productCtrl().updateMetaKeyword(keyword);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const Gap(Insets.lg),
                Text(
                  LocaleKeys.meta_description.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.med),
                FormBuilderTextField(
                  name: 'meta_description',
                  initialValue: productState.metaDescription,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.meta_description.tr(),
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
