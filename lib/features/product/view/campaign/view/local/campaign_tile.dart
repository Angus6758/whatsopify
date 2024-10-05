
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/campaign/controller/campaign_ctrl.dart';
import 'package:seller_management/features/product/view/campaign/view/local/campaign_loader.dart';
import 'package:seller_management/features/product/view/content/campaign_models.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/strings/hero_tags.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../../_widgets/app_image.dart';
import '../../../../../../_widgets/hero_widget.dart';
import '../../../../../../_widgets/time_countdown.dart';

class CampaignTile extends ConsumerWidget {
  const CampaignTile({super.key, required this.campaign});

  final CampaignModel campaign;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignData = ref.watch(campaignCtrlProvider(campaign.uid));
    final campaignCtrl = ref.read(campaignCtrlProvider(campaign.uid).notifier);

    return campaignData.when(
      error: (e, s) => ErrorView1.reload(e, s, () => campaignCtrl.reload()),
      loading: () => const CampaignLoader(),
      data: (campaign) {
        return GestureDetector(
          onTap: () {
            RouteNames.campaignDetails.pushNamed(context,
                pathParams: {'id': campaign.campaign.uid},
                query: {'name': campaign.campaign.name});
          },
          child: Stack(
            children: [
              HeroWidget(
                tag: campaign.campaign.uid,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: HostedImage.provider(
                        campaign.campaign.image,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TimerCountdown(
                          color: context.colors.surface,
                          duration: campaign.campaign.endTime.difference(
                            DateTime.now(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        color: context.colors.surface,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            color: context.colors.primaryContainer
                                .withOpacity(context.isDark ? 0.3 : 0.04),
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      height: 160,
                      width: context.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: HeroWidget(
                                    tag: campaign.campaign.name,
                                    child: Text(
                                      campaign.campaign.name,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          context.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: campaign.products.listData.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return HeroWidget(
                                    tag: HeroTags.productImgTag(
                                      campaign.products.listData[index],
                                      campaign.campaign.uid,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0,
                                          color: context.colors.primary,
                                        ),
                                        borderRadius: defaultRadius,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 3,
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: defaultRadiusOnlyTop,
                                            child: HostedImage(
                                              campaign.products.listData[index]
                                                  .featuredImage,
                                              height: 70,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            campaign.products.listData[index]
                                                .discountAmount
                                                .formate(),
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
