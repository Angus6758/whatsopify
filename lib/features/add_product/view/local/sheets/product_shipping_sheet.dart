import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/add_product/controller/add_product_ctrl.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/main.export.dart';

class ProductShippingSheet extends HookConsumerWidget {
  const ProductShippingSheet({
    super.key,
    required this.editingProduct,
  });

  final ProductModel? editingProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shippingList =
        ref.watch(localAuthConfigProvider.select((v) => v?.shippingInfo));
    final PhysicalStoreState(:shippingDeliveryIds) =
        ref.watch(physicalStoreCtrlProvider(editingProduct));

    final productCtrl = useCallback(
        () => ref.read(physicalStoreCtrlProvider(editingProduct).notifier));

    bool doesContainsId(String id) =>
        shippingDeliveryIds?.contains(id) ?? false;

    final selected =
        shippingList?.where((e) => doesContainsId('${e.id}')).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: context.height / 2,
        child: ShadowContainer(
          child: Padding(
            padding: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.product_shipping.tr(),
                  style: context.textTheme.titleLarge,
                ),
                const Gap(Insets.med),
                const Divider(),
                const Gap(Insets.med),
                Text(
                  LocaleKeys.shipping_area.tr(),
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(Insets.sm),
                if (shippingList != null && shippingList.isNotEmpty) ...[
                  FormBuilderDropField<int>(
                    name: 'shipping_delivery_id',
                    itemCount: shippingList.length,
                    hintText: LocaleKeys.select_item.tr(),
                    onChanged: (v) {
                      if (v == -1) {
                        for (var ship in shippingList) {
                          productCtrl().addShippingId(ship.id.toString());
                        }
                        return;
                      }
                      productCtrl().addShippingId(v.toString());
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return DropdownMenuItem(
                          value: -1,
                          child: Text(LocaleKeys.all.tr()),
                        );
                      }
                      final shipping = shippingList[index - 1];
                      return DropdownMenuItem(
                        value: shipping.id,
                        child: Text(shipping.methodName),
                      );
                    },
                  ),
                  const Gap(Insets.def),
                  if (selected != null)
                    Wrap(
                      spacing: Insets.def,
                      runSpacing: Insets.def,
                      children: [
                        ...selected.map(
                          (e) => SimpleChip(
                            label: e.methodName,
                            onDeleteTap: () =>
                                productCtrl().removeShippingId('${e.id}'),
                          ),
                        ),
                      ],
                    ),
                ] else
                  WarningBox(
                    LocaleKeys.no_shipping_delivery_provider_found.tr(),
                  ),
                const Gap(Insets.offset),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          productCtrl().setBrand(null);
                          context.pop();
                        },
                        child: Text(
                          LocaleKeys.clear.tr(),
                        ),
                      ),
                    ),
                    const Gap(Insets.def),
                    Expanded(
                      child: SubmitButton.dense(
                        onPressed: (l) => context.pop(),
                        child: Text(
                          LocaleKeys.submit.tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
