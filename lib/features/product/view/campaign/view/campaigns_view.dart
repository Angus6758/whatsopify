
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/campaign/providers/campaign_provider.dart';
import 'package:seller_management/features/product/view/campaign/view/local/campaign_loader.dart';
import 'package:seller_management/features/product/view/campaign/view/local/campaign_tile.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/list_view_with_footer.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

class CampaignsView extends ConsumerWidget {
  const CampaignsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignData = ref.watch(campaignListProvider);

    return Scaffold(
      appBar: KAppBar(title: Text(TR.campaign(context))),
      body: RefreshIndicator(
        onRefresh: () => ref.read(campaignListProvider.notifier).reload(),
        child: campaignData.when(
          loading: () => const CampaignLoader(),
          error: ErrorView1.errorMethod,
          data: (campaign) {
            final ItemListWithPageData(:listData, :pagination) = campaign;
            return ListViewWithFooter(
              onNext: () {
                ref.read(campaignListProvider.notifier).next();
              },
              onPrevious: () {
                ref.read(campaignListProvider.notifier).previous();
              },
              itemCount: listData.length,
              pagination: pagination,
              physics: defaultScrollPhysics,
              emptyListWidget:
                  const Center(child: NoItemsAnimationWithFooter()),
              itemBuilder: (context, index) => SizedBox(
                height: 280,
                child: CampaignTile(
                  campaign: listData[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
