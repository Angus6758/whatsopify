

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/brands/provider/brand_provider.dart';
import 'package:seller_management/features/product/view/categories/providers/categories_provider.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/products/controller/filtering_ctrl.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/state/product_filtering_state.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet(this.args, this.localSearch, {super.key});

  final FilterArgs args;
  final String localSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range =
        ref.watch(settingsProvider.select((x) => x?.settings.filterRange));
    final categories = ref.watch(categoryListProvider);
    final brands = ref.watch(brandListProvider);
    final filtered = ref.watch(filteringCtrlProvider(args));
    final minPriceCtrl = useTextEditingController();
    final maxPriceCtrl = useTextEditingController();

    final filterCtrl =
        useCallback(() => ref.read(filteringCtrlProvider(args).notifier));

    final onReset = useCallback(() {
      minPriceCtrl.clear();
      maxPriceCtrl.clear();
      filterCtrl().reset();
      context.pop();
    }, const []);

    final onSubmit = useCallback(() async {
      context.pop();
      await filterCtrl().setMin(minPriceCtrl.text);
      await filterCtrl().setMax(maxPriceCtrl.text);
      await filterCtrl().filter(localSearch);
    }, const []);

    useEffect(() {
      final value = filtered.valueOrNull;
      minPriceCtrl.text = value?.min ?? '';
      maxPriceCtrl.text = value?.max ?? '';
      return null;
    }, const []);

    return Card(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  TR.filters(context),
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 3,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: context.colors.primary,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: filtered.when(
              loading: Loader1.loading,
              error: ErrorView1.errorMethod,
              data: (filterData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          TR.sortWithPrice(context),
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: minPriceCtrl,
                                decoration: InputDecoration(
                                  hintText:
                                      '${TR.min(context)} ${range?.start.formate()}',
                                  suffixIcon: IconButton(
                                    onPressed: () => minPriceCtrl.clear(),
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 1,
                              width: 20,
                              color: context.colors.outline,
                            ),
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: maxPriceCtrl,
                                decoration: InputDecoration(
                                  hintText:
                                      '${TR.max(context)} ${range?.start.formate()}',
                                  suffixIcon: IconButton(
                                    onPressed: () => maxPriceCtrl.clear(),
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          TR.sortOrder(context),
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...SortType.values.map(
                              (e) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: e == filterData.sortType
                                          ? context.colors.primary
                                          : Colors.transparent,
                                      side: e == filterData.sortType
                                          ? BorderSide(
                                              width: 1.5,
                                              color: context.colors.primary,
                                            )
                                          : null,
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () =>
                                        filterCtrl().setSortType(e),
                                    child: Text(
                                      e.translated(context),
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                        color: e == filterData.sortType
                                            ? context.colors.onPrimary
                                            : context.colors.secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              TR.category(context),
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: context.colors.secondaryContainer
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 2,
                                ),
                                child: Text(
                                  categories.length.toString(),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colors.secondaryContainer
                                .withOpacity(0.05),
                          ),
                          child: InkWell(
                            borderRadius: defaultRadius,
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (_) => FilterNSearchListDialog(
                              //     labelBuilder: (value) => value.name,
                              //     hinText: TR.searchCategories(context),
                              //     onConfirm: (data) {
                              //       ref
                              //           .read(filteringCtrlProvider(args)
                              //               .notifier)
                              //           .setCategory(data);
                              //     },
                              //     title: TR.searchCategories(context),
                              //     listData: categories,
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    filterData.category?.name ??
                                        TR.select(context),
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Icon(Icons.arrow_downward),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (args.type != 'digital') ...[
                          Row(
                            children: [
                              Text(
                                TR.brands(context),
                                style: context.textTheme.titleMedium,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: context.colors.secondaryContainer
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    brands.length.toString(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: defaultRadius,
                              color: context.colors.secondaryContainer
                                  .withOpacity(0.05),
                            ),
                            child: InkWell(
                              borderRadius: defaultRadius,
                              // onTap: () => showDialog(
                              //   context: context,
                              //   builder: (_) => FilterNSearchListDialog(
                              //     labelBuilder: (value) => value.name,
                              //     hinText: TR.searchBrands(context),
                              //     onConfirm: (data) =>
                              //         filterCtrl().setBrand(data),
                              //     title: TR.brands(context),
                              //     listData: brands,
                              //   ),
                              // ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      filterData.brand?.name ??
                                          TR.select(context),
                                      style: context.textTheme.titleMedium,
                                    ),
                                    const Icon(Icons.arrow_downward),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onReset(),
                      child: Text(TR.reset(context)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => onSubmit(),
                      child: Text(TR.submit(context)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
