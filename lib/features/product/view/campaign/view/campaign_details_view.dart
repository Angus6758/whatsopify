
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/campaign/controller/campaign_ctrl.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/m_grid_view_with_footer.dart';
import 'package:seller_management/features/product/view/products/view/local/product_card.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../_widgets/app_image.dart';
import '../../../../../_widgets/hero_widget.dart';
import '../../../../../_widgets/shimmer.dart';
import '../../../../../_widgets/time_countdown.dart';

class CampaignDetailsView extends HookConsumerWidget {
  const CampaignDetailsView(this.campaignId, {super.key});

  final String campaignId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = context.query('name');
    final campaignData = ref.watch(campaignCtrlProvider(campaignId));
    final campaignCtrl =
        useCallback(() => ref.read(campaignCtrlProvider(campaignId).notifier));

    return Scaffold(
      appBar: KAppBar(
        title: HeroWidget(
          tag: name ?? '',
          child: Text(
            name ?? TR.campaign(context),
            maxLines: 1,
            style: context.textTheme.titleLarge
                ?.copyWith(color: context.colors.onPrimary),
          ),
        ),
        color: context.colors.primary,
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => campaignCtrl().reload(),
        child: SingleChildScrollView(
          physics: defaultScrollPhysics,
          child: campaignData.when(
            error: (e, s) =>
                ErrorView1.reload(e, s, () => campaignCtrl().reload()),
            loading: () => GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return KShimmer.card();
              },
            ),
            data: (campaign) => Column(
              children: [
                HeroWidget(
                  tag: campaignId,
                  child: HostedImage(
                    campaign.campaign.image,
                    height: 180,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: defaultPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TR.allProduct(context),
                            style: context.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 2,
                            width: context.width / 3,
                            color: context.colors.primary,
                          ),
                        ],
                      ),
                      TimerCountdown(
                        color: context.colors.surface,
                        duration: campaign.campaign.endTime.difference(
                          DateTime.now(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: defaultPaddingAll,
                  child: MGridViewWithFooter(
                    crossAxisCount: context.onMobile ? 2 : 4,
                    mainAxisSpacing: context.onMobile ? 10 : 20,
                    crossAxisSpacing: context.onMobile ? 10 : 20,
                    itemCount: campaign.products.listData.length,
                    pagination: campaign.products.pagination,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onNext: () => campaignCtrl().next(),
                    onPrevious: () => campaignCtrl().previous(),
                    builder: (BuildContext context, int index) {
                      return ProductCard(
                        cId: campaign.campaign.uid,
                        product: campaign.products.listData[index],
                        type: campaignId,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
