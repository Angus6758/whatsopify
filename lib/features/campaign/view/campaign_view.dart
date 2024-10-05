import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

class CampaignView extends ConsumerWidget {
  const CampaignView(this.campaign, {super.key});
  final CampaignModel campaign;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime time = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp'),
      ),
      body: Column(
        children: [
          HostedImage(
            campaign.image,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Gap(Insets.med),
          Padding(
            padding: Insets.padH,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Product',
                      style: context.textTheme.titleLarge,
                    ),
                    TimerCountdown(
                      color: context.colorTheme.onPrimary,
                      duration: time.timeZoneOffset,
                    ),
                  ],
                ),
                const Gap(Insets.med),
                GridViewWithFooter(
                  shrinkWrap: true,
                  itemCount: campaign.products.length,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: context.onMobile ? 2 : 4,
                  builder: (context, index) => CampaignProductCard(
                    product: campaign.products[index],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CampaignProductCard extends StatelessWidget {
  const CampaignProductCard({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouteNames.productDetails
          .pushNamed(context, pathParams: {'id': product.uid}),
      child: Stack(
        children: [
          ShadowContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Corners.medRadius,
                  ),
                  child: HostedImage(
                    product.featuredImage,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: Insets.padAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: context.textTheme.bodyLarge,
                      ),
                      const Gap(Insets.sm),
                      if (product.totalOrderCount != 0)
                        Text(
                          'Total Order: ${product.totalOrderCount.toString()}',
                          style: context.textTheme.bodyLarge,
                        ),
                      const Gap(Insets.sm),
                      Row(
                        children: [
                          Text(
                            product.discount == 0
                                ? product.price.formate()
                                : product.discount.formate(),
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorTheme.primary,
                            ),
                          ),
                          const Gap(Insets.sm),
                          if (product.discount != 0)
                            Text(
                              product.price.formate(),
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: context.colorTheme.primary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorTheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(Corners.med),
                  topRight: Radius.circular(Corners.med),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  '${product.discountPercentage.toString()}% OFF',
                  style: TextStyle(
                    color: context.colorTheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
