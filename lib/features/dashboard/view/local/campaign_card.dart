import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.campaign,
  });
  final CampaignModel campaign;
  @override
  Widget build(BuildContext context) {
    final DateTime time = DateTime.now();

    return ClipRRect(
      borderRadius: Corners.medBorder,
      child: Stack(
        children: [
          ShadowContainer(
            child: HostedImage(
              campaign.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              width: context.width / 2.2,
              child: Text(
                campaign.name,
                style: context.textTheme.titleLarge!.copyWith(
                  color: context.colorTheme.onPrimary,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorTheme.surface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Text(
                  campaign.discountType == 'percentage'
                      ? 'Upto ${campaign.discount.toString()}%'
                      : 'Get a flat ${campaign.discount.formate()} Discount',
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: TimerCountdown(
              color: context.colorTheme.onPrimary,
              duration: time.timeZoneOffset,
            ),
          ),
        ],
      ),
    );
  }
}
