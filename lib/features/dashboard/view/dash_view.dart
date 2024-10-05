import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/product/view/campaign/controller/campaign_ctrl.dart';
import 'package:seller_management/features/product/view/campaign/providers/campaign_provider.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';
import '../controller/dash_ctrl.dart';
import 'home_init_page.dart';
import 'local/local.dart';

class DashBoardView extends HookConsumerWidget {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashData = ref.watch(dashBoardCtrlProvider);
    final currentIndex = useState(0);
    final campaignList = ref.watch(campaignListProvider);
    return dashData.when(
      loading: () => const Scaffold(body: DashLoader()),
      error: (e, s) => Scaffold(body: ErrorView(e, s)),
      data: (dash) {
        return DashInitPage(
          child: Scaffold(
            appBar: KAppBar(
              color: context.colorTheme.onPrimary,
              title: Text(
                LocaleKeys.seller_center.tr(),
                style: TextStyle(
                  color: context.colorTheme.primary,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 10),
                child: DashboardPreferredSize(
                  dash: dash,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async =>
                  ref.read(dashBoardCtrlProvider.notifier).reload(),
              child: SingleChildScrollView(
                padding: Insets.padH,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(Insets.lg),
                    if (context.onMobile) ...[
                      DashTopAllCartMobileView(
                        dash: dash,
                      ),
                      const Gap(Insets.lg),
                    ],
                    if (context.onTab) ...[
                      DashTopAllCartTabView(
                        dash: dash,
                      ),
                      const Gap(Insets.lg),
                    ],
                    if (dash.seller.shop.isShopActive)
                      const ProductQuickActionCard(),
                    const Gap(Insets.lg),
                    Text(
                      LocaleKeys.monthly_order_overview.tr(),
                      style: context.textTheme.titleLarge,
                    ),
                    PieChartWidget(data: dash.graphData.monthlyOrderReport),
                    const Gap(Insets.lg),
                    //! line chart
                    Text(
                      LocaleKeys.all_order_overview.tr(),
                      style: context.textTheme.titleLarge,
                    ),

                    const Gap(Insets.lg),
                    Padding(
                      padding: const EdgeInsets.only(top: Insets.lg),
                      child: LineChartWidget(
                        data: dash.graphData.yearlyOrderReport,
                      ),
                    ),
                    const Gap(Insets.lg),

                    //! all transaction
                    TransactionLogTable(transactions: dash.transactions),

                    //! campaigns
                    if (dash.seller.shop.isShopActive)
                      campaignList.when(
                        loading: () => Loader.shimmer(160, context.width),
                        error: (e, s) =>
                            ErrorView(e, s, invalidate: campaignCtrlProvider),
                        data: (campaigns) {
                          if (campaigns.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.ongoing_campaign.tr(),
                                style: context.textTheme.titleLarge,
                              ),
                              const Gap(Insets.med),
                              CarouselSlider.builder(
                                options: CarouselOptions(
                                  onPageChanged: (index, _) =>
                                      currentIndex.value = index,
                                  enlargeFactor: 0,
                                  clipBehavior: Clip.none,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  height: context.onMobile ? 160 : 250,
                                  autoPlay: false,
                                ),
                                itemCount: campaignList.value!.length,
                                itemBuilder: (context, index, realIndex) {
                                  final campaign = campaignList.value![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: GestureDetector(
                                      onTap: () => RouteNames.campaign
                                          .pushNamed(context, extra: campaign),
                                      child: CampaignCard(
                                        campaign: campaign,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),

                    const Gap(Insets.lg),
                    DecoratedContainer(
                      child: Padding(
                        padding: Insets.padAll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.store_performance.tr(),
                              style: context.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(Insets.med),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OrderStatusCard(
                                    width: 120,
                                    height: 90,
                                    count:
                                        '${dash.overview.cancelOrderRate.toStringAsFixed(2)}%',
                                    status: LocaleKeys.cancel_rate.tr(),
                                  ),
                                  OrderStatusCard(
                                    width: 120,
                                    height: 90,
                                    count:
                                        '${dash.overview.deliveredOrderRate.toStringAsFixed(2)}%',
                                    status: LocaleKeys.delivery_rate.tr(),
                                  ),
                                  OrderStatusCard(
                                    width: 120,
                                    height: 90,
                                    count:
                                        '${dash.overview.physicalOrderRate.toStringAsFixed(2)}%',
                                    status: LocaleKeys.physical_order_rate.tr(),
                                  ),
                                  OrderStatusCard(
                                    width: 120,
                                    height: 90,
                                    count:
                                        '${dash.overview.digitalOrderRate.toStringAsFixed(2)}%',
                                    status: LocaleKeys.digital_order_rate.tr(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Gap(100),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
