
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/store/providers/store_providers.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../_widgets/appbar.dart';
import 'local/store_product_card.dart';

class AllStoreView extends ConsumerWidget {
  const AllStoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeList = ref.watch(storeListProvider);

    if (storeList == null) {
      return ErrorView1.withScaffold('Something went wrong');
    }

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(TR.store(context)),
      ),
      body: Padding(
        padding: defaultPadding.copyWith(top: 10),
        child: RefreshIndicator(
          onRefresh: () async {
            return ref.refresh(storeListProvider);
          },
          child: MasonryGridView.builder(
            shrinkWrap: true,
            physics: defaultScrollPhysics,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.onMobile ? 2 : 3,
            ),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            clipBehavior: Clip.none,
            itemCount: storeList.listData.length,
            itemBuilder: (BuildContext context, int index) {
              return StoreProductCard(
                store: storeList.listData[index],
                direction: Axis.vertical,
              );
            },
          ),
        ),
      ),
    );
  }
}
