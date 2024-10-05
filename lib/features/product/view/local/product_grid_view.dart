import 'package:flutter/material.dart';
import 'package:seller_management/features/product/controller/list_ctrls.dart';
import 'package:seller_management/main.export.dart';

class ProductGridView extends HookConsumerWidget {
  const ProductGridView({
    super.key,
    required this.status,
    required this.childBuilder,
    required this.isDigital,
  });
  final String? status;
  final bool isDigital;
  final Widget Function(ProductModel product) childBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productData = isDigital
        ? ref.watch(digitalProductCtrlProvider(status))
        : ref.watch(physicalProductCtrlProvider(status));

    final phyCtrl = useCallback(
        () => ref.read(physicalProductCtrlProvider(status).notifier));

    final digitalCtrl = useCallback(
        () => ref.read(digitalProductCtrlProvider(status).notifier));
    final searchCtrl = useTextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  searchCtrl.clear();
                  if (isDigital) {
                    digitalCtrl().reload();
                  } else {
                    phyCtrl().reload();
                  }
                },
                icon: const Icon(Icons.clear_rounded),
              ),
              hintText: 'Search via name',
            ),
            onChanged: (value) {
              if (isDigital) {
                digitalCtrl().search(value);
              } else {
                phyCtrl().search(value);
              }
            },
          ),
        ),
        Expanded(
          child: productData.when(
            loading: () => Loader.grid(6),
            error: ErrorView.new,
            data: (products) {
              return Padding(
                padding: Insets.padH.copyWith(top: 10, bottom: 10),
                child: RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(physicalProductCtrlProvider(status)),
                  child: GridViewWithFooter(
                    crossAxisCount: context.onMobile ? 2 : 4,
                    shrinkWrap: true,
                    itemCount: products.length,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    pagination: products.pagination,
                    onNext: (url) {
                      if (isDigital) {
                        digitalCtrl().productByUrl(url);
                      } else {
                        phyCtrl().productByUrl(url);
                      }
                    },
                    onPrevious: (url) {
                      if (isDigital) {
                        digitalCtrl().productByUrl(url);
                      } else {
                        phyCtrl().productByUrl(url);
                      }
                    },
                    builder: (context, index) => childBuilder(products[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
